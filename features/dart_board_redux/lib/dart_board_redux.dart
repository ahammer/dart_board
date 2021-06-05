import 'package:dart_board_core/dart_board.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

///-----------------------------------------------------------------------------
/// The extension itself. It provides a Redux store to access as a App Decoration
/// Generally this should end up near the root of the tree
class DartBoardRedux extends DartBoardFeature {
  @override
  String get namespace => "redux";

  @override
  List<DartBoardDecoration> get appDecorations => [
        DartBoardDecoration(
            name: "redux store",
            decoration: (ctx, child) => StoreProvider(
                key: Key("redux_store"), store: store, child: child))
      ];
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

/// This is our store in global scope accessible everywhere
final Store<DartBoardState> store =
    Store(_reducer, initialState: DartBoardState(data: {}));

/// This is the main reducer, It'll handle creating a new DartBoardState
DartBoardState _reducer(DartBoardState state, action) {
  if (action is ReductionDelegate<DartBoardState>) {
    return action(state);
  }
  return state;
}

// Dynamic Dispatch
void dispatch<T>(dynamic dispatchable, {String instance = ""}) {
  if (Object() is T) throw Exception("Can't take dynamic here");
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
                StateFactoryConnector<T>(factory: factory, child: child));
}

class StateFactoryConnector<T> extends StatefulWidget {
  final Widget child;
  final StateFactory<T> factory;

  const StateFactoryConnector(
      {Key? key, required this.factory, required this.child})
      : super(key: key);

  @override
  _StateFactoryConnectorState<T> createState() =>
      _StateFactoryConnectorState<T>();
}

class _StateFactoryConnectorState<T> extends State<StateFactoryConnector<T>> {
  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void initState() {
    _factories[T] = widget.factory;
    super.initState();
  }
}
