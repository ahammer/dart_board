import 'package:dart_board_core/dart_board.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

final _dartBoardReduxKey = GlobalKey<_DartBoardStoreWidgetState>();

/// The feature itself
class DartBoardRedux extends DartBoardFeature {
  @override
  String get namespace => "redux";

  @override
  List<DartBoardDecoration> get appDecorations => [
        DartBoardDecoration(
            name: "redux_store",
            decoration: (ctx, child) =>
                _DartBoardStoreWidget(key: _dartBoardReduxKey, child: child))
      ];
}

///-----------------------------------------------------------------------------
///                    PUBLIC API
///
/// Usage:
///  Include the Feature
///
///  Use: ReduxStateProviderDecoration() App Decoration
///    e.g. `ReduxStateProviderDecoration<FeatureState>(name: 'feature_state`, factory: () => FeatureState())`
///    for features to provide state objects.
///
///  FeatureState state = getState<FeatureState>();

T getState<T>({String instance_id = ""}) =>
    _dartBoardReduxKey.currentState!.store.state
        .getState<T>(instance_id: instance_id);

///  # Decorations
///  These can help integrate Redux into your feature
///  They are both recommended to be App decorations.
///
///  ## ReduxStateDecoration<StateType>({required this.factory, required this.name})
///  Manufactures a default state object for Redux. Add state types to your feature
///  with this.
/// Usage: StateFactoryConnector<type>(name: "your state label", ()=>YourState(initial_settings))

class ReduxStateDecoration<T> extends DartBoardDecoration {
  final String name;
  final StateFactory<T> factory;

  ReduxStateDecoration({required this.factory, required this.name})
      : super(
            name: name,
            decoration: (ctx, child) =>
                _StateFactoryConnector<T>(factory: factory, child: child));
}

///  ##  ReduxMiddlewareDecoration({required this.name, required this.middleware})
///  Connects Middleware to the Redux Store (e.g. Epics, Thunks)
class ReduxMiddlewareDecoration extends DartBoardDecoration {
  final String name;
  final Middleware<DartBoardState> middleware;

  ReduxMiddlewareDecoration({required this.name, required this.middleware})
      : super(
            name: name,
            decoration: (context, child) => _MiddlewareInjector(
                name: name, middleware: middleware, child: child));
}

///  # Widgets
///
/// ReduxBuilder<YourState>(builder: (context, yourState)=>YourWidget())
///
/// Simple rebuild hook to your state.
///
//setState(() => _initStore());

class ReduxBuilder<T> extends StatelessWidget {
  final String instance_id;
  final Widget Function(BuildContext context, T state) builder;
  final bool distinct;

  const ReduxBuilder(this.builder,
      {Key? key, this.distinct = false, this.instance_id = ""})
      : super(key: key);

  @override
  Widget build(BuildContext context) => StoreConnector<DartBoardState, T>(
      converter: (store) => store.state.getState(),
      distinct: distinct,
      builder: builder);
}

/// # Actions and Dispatching
///
/// use dispatch or dispatchFunc to throw actions
///
/// - You can extend ReduxAction<T> to define an action
/// - or you can use dispatchFunc<T>(T Function(T))

// # Normal Dispatch
void dispatch(dynamic dispatchable) =>
    _dartBoardReduxKey.currentState!.store.dispatch(dispatchable);

// # Functional Dispatch
void dispatchFunc<T>(T Function(T oldState) func) =>
    dispatch(_FunctionReduxAction<T>((state) => func(state)));

// # Interface for Reducing an action
abstract class BaseReducable {
  DartBoardState reduce(DartBoardState oldState);
}

// # Abstract class to reduce a specific state in the store
abstract class ReduxAction<T> extends BaseReducable {
  final String instance_id;

  ReduxAction({this.instance_id = ""});

  @override
  DartBoardState reduce(DartBoardState oldState) {
    final state = featureReduce(oldState.getState(instance_id: instance_id));

    final data = <Type, Map<String, dynamic>>{}
      ..addAll(oldState.data)
      ..putIfAbsent(T, () => <String, dynamic>{});
    data[T]?[instance_id] = state;
    return DartBoardState(data: data, factories: oldState.factories);
  }

  T featureReduce(T state);
}

///
///-----------------------------------------------------------------------------
///                     IMPLEMENTATION DETAILS
///
/// This is a meta-redux store. The store itself can be though of a
/// warehouse of states.
///
/// The state itself contains 1 field. The warehouse.
///
/// It is a 3D Map.
///
/// [State Type] -> [Instance ID (default "")] -> [DATA]
///
/// The reason for this mapping is for the features.
///
/// - Features are allowed to add any State types they want
/// - Features might want multiple instances
///
///
/// To enable this, we also need to bring in the concept of State Factories.
/// State factories will tell our Redux implementation how to build an Object
/// if we don't have one.
///
typedef StateFactory<T> = T Function();

///
/// getState() itself generates the State from the object if it doesn't exist.
/// When reducing a feature, this fallback creates the initial state, and
/// ensures getState() never returns null for a registered state.
///
///
///

/// Used to manage the life-cycle, inject Middleware into Redux
class _MiddlewareInjector extends StatefulWidget {
  final String name;
  final Widget child;
  final Middleware<DartBoardState> middleware;

  const _MiddlewareInjector(
      {Key? key,
      required this.name,
      required this.middleware,
      required this.child})
      : super(key: key);

  @override
  __MiddlewareInjectorState createState() => __MiddlewareInjectorState();
}

class __MiddlewareInjectorState extends State<_MiddlewareInjector> {
  @override
  void initState() {
    _dartBoardReduxKey.currentState
        ?.registerMiddleware(widget.name, widget.middleware);
    super.initState();
  }

  @override
  void dispose() {
    _dartBoardReduxKey.currentState?.unregisterMiddleware(widget.name);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Holds the store and provides it
class _DartBoardStoreWidget extends StatefulWidget {
  final Widget child;

  const _DartBoardStoreWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _DartBoardStoreWidgetState createState() => _DartBoardStoreWidgetState();
}

class _DartBoardStoreWidgetState extends State<_DartBoardStoreWidget> {
  /// This is our store in global scope accessible everywhere
  late Store<DartBoardState> store;

  /// Snapshot for when we rebuild the store. Starts out blank
  var _snapshot = <Type, Map<String, dynamic>>{};
  final _factories = <Type, StateFactory<dynamic>>{};

  Map<String, Middleware<DartBoardState>> middleware = {};

  void registerFactory<T>(StateFactory<T> factory) {
    _factories[T] = factory;
    setState(() => _initStore());
  }

  void registerMiddleware(String name, Middleware<DartBoardState> entry) {
    middleware[name] = entry;

    /// Take a snapshot before we re-init the store
    _snapshot = store.state.data;
    setState(() => _initStore());
  }

  /// Make this safe
  @override
  void setState(VoidCallback fn) => WidgetsBinding.instance
      ?.scheduleFrameCallback((timeStamp) => super.setState(fn));

  void unregisterMiddleware(String name) {
    middleware.remove(name);

    /// Take a snapshot before we re-init the store
    _snapshot = store.state.data;
    setState(() => _initStore());
  }

  @override
  void initState() {
    _initStore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      StoreProvider(key: Key("redux_store"), store: store, child: widget.child);

  /// Initialize the store
  void _initStore() {
    store = Store(_reducer,
        initialState: DartBoardState(data: _snapshot, factories: _factories),
        middleware: [
          ...middleware.values,
        ]);
  }
}

/// Wrapper to dispatch things functionally.
class _FunctionReduxAction<T> extends ReduxAction<T> {
  final T Function(T state) func;

  _FunctionReduxAction(this.func);
  @override
  T featureReduce(T state) => func(state);
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
  final Map<Type, StateFactory<dynamic>> factories;

  /// Constructor, takes the data
  DartBoardState({required this.data, required this.factories});

  /// Gets a state object, or builds it if it doesn't exist
  T getState<T>({String instance_id = ""}) {
    if (factories[T] == null) {
      throw Exception(
          "Dart Board Redux: We can't get $T because it has no registered State Factory. Please add a ReduxStateProviderDecoration<$T> in your feature.");
    }
    return data[T]?[instance_id] ?? factories[T]?.call() as T;
  }
}

/// This is the main reducer, It'll handle creating a new DartBoardState
DartBoardState _reducer(DartBoardState state, action) {
  if (action is BaseReducable) {
    return action.reduce(state);
  }
  return state;
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
    _dartBoardReduxKey.currentState?.registerFactory(widget.factory);
    super.initState();
  }
}
