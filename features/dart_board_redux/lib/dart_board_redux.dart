import 'package:dart_board_core/dart_board.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

final _dartBoardReduxKey = GlobalKey<_DartBoardStoreWidgetState>();

///-----------------------------------------------------------------------------
///                    PUBLIC API
///
/// Usage:
///  Include the Feature
///  Use: ReduxStateProviderDecoration() App Decoration
///    e.g. `ReduxStateProviderDecoration<FeatureState>(name: 'feature_state`, factory: () => FeatureState())`
///    for features to provide state objects.
///
///  FeatureState state = getState<FeatureState>();
///
/// The extension itself. It provides a Redux store to access as a App Decoration
/// Generally this should end up near the root of the tree
class DartBoardRedux extends DartBoardFeature {
  @override
  String get namespace => "redux";

  @override
  List<DartBoardDecoration> get appDecorations => [
        DartBoardDecoration(
            name: "redux store",
            decoration: (ctx, child) =>
                DartBoardStoreWidget(key: _dartBoardReduxKey, child: child))
      ];
}

///----------------------------------------------------------------------------
/// App Decoration API to hook up state objects
///
/// Usage: StateFactoryConnector<type>(name: "your state label", ()=>YourState(initial_settings))
class ReduxStateProviderDecoration<T> extends DartBoardDecoration {
  final String name;
  final StateFactory<T> factory;

  ReduxStateProviderDecoration({required this.factory, required this.name})
      : super(
            name: name,
            decoration: (ctx, child) =>
                _StateFactoryConnector<T>(factory: factory, child: child));
}

/// Widget to hook up a state object
/// Users can use this to update their UI as a State object changes
class ReduxStateUpdater<T> extends StatelessWidget {
  final Widget Function(BuildContext context, T state) builder;
  final bool distinct;

  const ReduxStateUpdater(this.builder, {Key? key, this.distinct = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) => StoreConnector<DartBoardState, T>(
      converter: (store) => store.state.getState(),
      distinct: distinct,
      builder: builder);
}

/// Call Dispatch(action) from anywhere
void dispatch<T>(dynamic dispatchable, {String instance_id = ""}) {
  if (Object() is T) throw Exception("Can't take dynamic here");
  final store = _dartBoardReduxKey.currentState!.store;
  if (dispatchable is ReductionDelegate<T>) {
    /// We reduce here and just install the new State
    store.dispatch(_InstallNewFeatureState(
        state: dispatchable(store.state.getState<T>(instance_id: instance_id)),
        instance_id: instance_id));
  } else if (dispatchable is Reducable<T>) {
    store.dispatch(_InstallNewFeatureState(
        state: dispatchable
            .reduce(store.state.getState<T>(instance_id: instance_id)),
        instance_id: instance_id));
  }
}

/// T getState<T>()
///
/// Can use this anywhere to pull a state
T getState<T>({String instance_id = ""}) =>
    _dartBoardReduxKey.currentState!.store.state
        .getState<T>(instance_id: instance_id);

/// Holds the store and provides it
class DartBoardStoreWidget extends StatefulWidget {
  final Widget child;

  const DartBoardStoreWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _DartBoardStoreWidgetState createState() => _DartBoardStoreWidgetState();
}

class _DartBoardStoreWidgetState extends State<DartBoardStoreWidget> {
  /// This is our store in global scope accessible everywhere
  late Store<DartBoardState> store;

  /// Snapshot for when we rebuild the store. Starts out blank
  var _snapshot = <Type, Map<String, dynamic>>{};

  Map<String, Middleware<DartBoardState>> middleware = {};

  void registerMiddleware(String name, Middleware<DartBoardState> entry) {
    middleware[name] = entry;

    /// Take a snapshot before we re-init the store
    _snapshot = store.state.data;
    setState(() => initStore());
  }

  void unregisterMiddleware(String name) {
    middleware.remove(name);

    /// Take a snapshot before we re-init the store
    _snapshot = store.state.data;
    setState(() => initStore());
  }

  @override
  void initState() {
    initStore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      StoreProvider(key: Key("redux_store"), store: store, child: widget.child);

  void initStore() {
    store = Store(_reducer,
        initialState: DartBoardState(data: _snapshot),
        middleware: middleware.values.toList());
  }
}

/// A type to indicate a function that constructs an initial state
typedef StateFactory<T> = T Function();

/// This is a delegate for Reducing.
///
/// This is actually what we'll dispatch
typedef ReductionDelegate<T> = T Function(T oldState);

/// State Factories
///
/// These are the Types supported by Redux
/// They factories are stored in a global map.
final Map<Type, StateFactory<dynamic>> _factories = {};

/// A class wrapper for a Reducable object
/// This is useful if you like to wrap you Actions in objects
/// Which can be useful if you want to leverage the type
/// system when handling redux
abstract class Reducable<T> {
  abstract final ReductionDelegate<T> reduce;
}

///-----------------------------------------------------------------------------
/// The state object itself
///
/// Our state object is only a map of data.
/// Dart Board will abstract this away to the user
///
/// However, we won't ever put any feature-state in here directly
class DartBoardState {
  /// We track data for the extensions
  /// Type => Instance => Data
  final Map<Type, Map<String, dynamic>> data;

  /// Constructor, takes the data
  DartBoardState({required this.data});

  /// Gets a state object, or builds it if it doesn't exist
  T getState<T>({String instance_id = ""}) {
    if (_factories[T] == null) {
      throw Exception(
          "Dart Board Redux: We can't get $T because it has no registered State Factory. Please add a ReduxStateProviderDecoration<$T> in your feature.");
    }
    return data[T]?[instance_id] ?? _factories[T]?.call() as T;
  }
}

/// This is the main reducer, It'll handle creating a new DartBoardState
DartBoardState _reducer(DartBoardState state, action) {
  if (action is ReductionDelegate<DartBoardState>) {
    return action(state);
  } else if (action is Reducable<DartBoardState>) {
    return action.reduce(state);
  }
  return state;
}

/// After we Reduce a feature's state, we install it with this reducable
class _InstallNewFeatureState<T> extends Reducable<DartBoardState> {
  final T state;
  final String instance_id;

  _InstallNewFeatureState({required this.state, this.instance_id = ""});

  @override
  ReductionDelegate<DartBoardState> get reduce => (oldState) {
        final data = <Type, Map<String, dynamic>>{}
          ..addAll(oldState.data)
          ..putIfAbsent(T, () => <String, dynamic>{});
        data[T]?[instance_id] = state;
        return DartBoardState(data: data);
      };
}

class _StateFactoryConnector<T> extends StatefulWidget {
  final Widget child;
  final StateFactory<T> factory;

  const _StateFactoryConnector(
      {Key? key, required this.factory, required this.child})
      : super(key: key);

  @override
  _StateFactoryConnectorState<T> createState() =>
      _StateFactoryConnectorState<T>();
}

class _StateFactoryConnectorState<T> extends State<_StateFactoryConnector<T>> {
  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void initState() {
    _factories[T] = widget.factory;
    super.initState();
  }
}
