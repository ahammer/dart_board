import 'package:dart_board_core/dart_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux/redux.dart';

///-----------------------------------------------------------------------------
///                  DART BOARD REDUX
///
/// This documentation is written in a way to be read as reference or as an
/// article, top down. It'll begin discussing the public api and then move
/// deeper into the implementation, keeping code near the discussion.
///
///
/// Summary:
///
/// Integrates a Redux Store into your application
/// Provides App Decorations for features to expand Redux capabilities
/// This redux store uses Generic's to allow adapting to multiple features
/// in dart-board.
///
/// API:
///
/// # Functions
/// T getState<T>()
/// dispatch(FeatureAction<T>())
/// dispatchFunc(T action(T))
///
/// # Classes
/// class FeatureAction<T>
///
/// # Decorations
/// ReduxStateDecoration
/// ReduxMiddlewareDecoration
///
/// # Widget
/// FeatureStateBuilder<T>(builder:(ctx, t) => YourBuilder)
///
/// This API should be enough to expose redux functionality to
/// external features.
///
///

/// DartBoardRedux
/// - Add this to your dependencies:[]
/// and you should be good to go, it's the Feature itself
///
/// It provides one app decoration which is the
/// _DartBoardStoreWidget() which manages the store
/// for you.
///
/// It uses a global key so we can wire things up internally
/// but kept private so others don't abuse it.
class DartBoardRedux extends DartBoardFeature {
  DartBoardRedux(
      {

      /// If you want the Thunk Middleware attached
      this.includeThunk = true});

  @override
  String get namespace => "redux";

  final bool includeThunk;

  @override
  List<DartBoardDecoration> get appDecorations => [
        DartBoardDecoration(
            name: "redux_store",
            decoration: (ctx, child) => _DartBoardStoreWidget(
                  key: _dartBoardReduxKey,
                  child: child,
                  includeThunk: includeThunk,
                ))
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

T getState<T>({String instanceId = ""}) =>
    _dartBoardReduxKey.currentState!.store.state
        .getState<T>(instanceId: instanceId);

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
            decoration: (ctx, child) => LifeCycleWidget(
                key: ValueKey("ReduxLifecycle"),
                child: child,
                init: (ctx) => _dartBoardReduxKey.currentState
                    ?._registerFactory(factory)));
  //_StateFactoryInjector<T>(factory: factory, child: child));
}

///  ##  ReduxMiddlewareDecoration({required this.name, required this.middleware})
///  Connects Middleware to the Redux Store (e.g. Epics, Thunks)
class ReduxMiddlewareDecoration extends DartBoardDecoration {
  final String name;
  final Middleware<DartBoardState> middleware;

  ReduxMiddlewareDecoration({required this.name, required this.middleware})
      : super(
          name: name,
          decoration: (context, child) => LifeCycleWidget(
              key: ValueKey("ReduxMiddleware+$name"),
              child: child,
              preInit: () => _dartBoardReduxKey.currentState
                  ?._registerMiddleware(name, middleware),
              dispose: (ctx) =>
                  _dartBoardReduxKey.currentState?._unregisterMiddleware(name)),
        );
}

///  # Widgets
///
/// ReduxBuilder<YourState>(builder: (context, yourState)=>YourWidget())
///
/// Simple rebuild hook to your state.
///
//setState(() => _initStore());

class FeatureStateBuilder<T> extends StatelessWidget {
  final String instanceId;
  final Widget Function(BuildContext context, T state) builder;
  final bool distinct;

  const FeatureStateBuilder(this.builder,
      {Key? key, this.distinct = false, this.instanceId = ""})
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
abstract class BaseAction {
  DartBoardState reduce(DartBoardState oldState);
}

// # Abstract class to reduce a specific state in the store
abstract class FeatureAction<T> extends BaseAction {
  final String instanceId;

  FeatureAction({this.instanceId = ""});

  @override
  DartBoardState reduce(DartBoardState oldState) {
    final state = featureReduce(oldState.getState(instanceId: instanceId));

    final data = <Type, Map<String, dynamic>>{}
      ..addAll(oldState.data)
      ..putIfAbsent(T, () => <String, dynamic>{});
    data[T]?[instanceId] = state;
    return DartBoardState(data: data, factories: oldState.factories);
  }

  T featureReduce(T state);
}

/// Wrapper to dispatch things functionally.
/// Used internally by dispatchFunc()
class _FunctionReduxAction<T> extends FeatureAction<T> {
  final T Function(T state) func;

  _FunctionReduxAction(this.func);
  @override
  T featureReduce(T state) => func(state);
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
/// This can all be seen in the DartBoardState
class DartBoardState {
  /// We track data for the extensions
  /// Type => Instance => Data
  final Map<Type, Map<String, dynamic>> data;

  /// These are the factories we use to make states lazily
  final Map<Type, StateFactory<dynamic>> factories;

  /// Constructor, takes the data and the current factories
  DartBoardState({required this.data, required this.factories});

  /// Gets a state object, or builds it if it doesn't exist
  T getState<T>({String instanceId = ""}) {
    /// GetState won't work without a registered factory.
    /// We won't even look for data.
    ///
    /// Nulls aren't allowed here, so if no factory what you get is an exception
    if (factories[T] == null) {
      throw Exception(
          "Dart Board Redux: We can't get $T because it has no registered State Factory. Please add a ReduxStateProviderDecoration<$T> in your feature.");
    }

    /// Return the data or generate the default
    return data[T]?[instanceId] ?? factories[T]!.call() as T;
  }
}

///
/// In redux you need to be able to 'reduce' state with an Action
///
/// In Dart Boards case, BaseAction is the type we use to delegate our
/// actions too.
///
/// The end user doesn't worry about that, using either
/// - dispatch(FeatureAction<T>)
/// - dispatchFunc(T (T old) {})
///
/// In fact, BaseAction is just an interface. The implementations are
/// FeatureAction
DartBoardState _reducer(DartBoardState state, action) {
  /// Here we reduce
  if (action is BaseAction) {
    return action.reduce(state);
  }

  /// Or just pass through
  return state;
}

///
/// Now that we know how the State is organized, and how new States are created
/// lets discuss the widget.
///
/// This is the AppDecoration that get's automatically added when you include
/// this feature.
///
/// It is a stateful widget and provides access to the store.
///
/// The state object itself exposes abilities to hook into the store
/// and rebuild it as necessary.
///
/// The widget itself is just a normal Decoration widget taking a child
///
class _DartBoardStoreWidget extends StatefulWidget {
  final Widget child;
  final bool includeThunk;

  const _DartBoardStoreWidget({
    Key? key,
    required this.child,
    required this.includeThunk,
  }) : super(key: key);

  @override
  _DartBoardStoreWidgetState createState() => _DartBoardStoreWidgetState();
}

///
/// The implementation here is where the Store itself is actually stored
/// We also can store a snapshot of data here when rebuilding
///
///
class _DartBoardStoreWidgetState extends State<_DartBoardStoreWidget> {
  /// This is our store in global scope accessible everywhere
  late Store<DartBoardState> store;

  /// Snapshot of data, also used as initial value
  /// and when rebuilding the store
  var _snapshot = <Type, Map<String, dynamic>>{};

  /// These are the factories. We put them in the State
  /// because this is where getState() lives and it needs them
  final _factories = <Type, StateFactory<dynamic>>{};

  /// Registered middleware
  final _middleware = <String, Middleware<DartBoardState>>{};

  /// Register a Type Factory
  ///
  /// This is a one-way operation. I didn't see the point of removal
  /// even if a feature using redux is disabled, we won't delete state.
  ///
  void _registerFactory<T>(StateFactory<T> factory) {
    _factories[T] = factory;
    setState(() => _initStore());
  }

  /// Register Middleware
  ///
  /// Used to register middleware into the system
  /// used by the Middleware app decoration widget
  void _registerMiddleware(String name, Middleware<DartBoardState> entry) {
    _middleware[name] = entry;

    /// Take a snapshot before we re-init the store
    _snapshot = store.state.data;
    setState(() => _initStore());
  }

  /// Remove Middleware from the system
  ///
  /// While we don't remove StateFactories, we do remove Middleware provided
  /// by features when they are disabled.
  void _unregisterMiddleware(String name) {
    _middleware.remove(name);

    /// Take a snapshot before we re-init the store
    _snapshot = store.state.data;
    setState(() => _initStore());
  }

  /// Additional safety is added to setState() since
  @override
  void setState(VoidCallback fn) => WidgetsBinding.instance
      ?.scheduleFrameCallback((timeStamp) => super.setState(fn));

  /// initState, and build the store
  @override
  void initState() {
    _initStore();
    super.initState();
  }

  /// Widget build, hooks up the Redux Store to the Tree
  @override
  Widget build(BuildContext context) =>
      StoreProvider(key: Key("redux_store"), store: store, child: widget.child);

  /// Initialize the store
  /// Uses the existing snapshot to initialize it
  ///
  /// Didn't use store.state.data because store is late
  /// would crash first run, can't self-reference.
  void _initStore() {
    store = Store(_reducer,
        initialState: DartBoardState(data: _snapshot, factories: _factories),
        middleware: [
          if (widget.includeThunk) thunkMiddleware,
          ..._middleware.values,
        ]);
  }
}

/// And that's really everything.
/// Finally,
///
/// This global key is used internally to wire things up, however let's talk about
/// that for a bit.
///
/// Global keys come with costs to use one, you have to guarantee that it will
/// only be used oncein the widget tree. They can be expensive, and can lead to
/// spaghetti like code. if people start passing them around.
///
/// Here however, Redux represents a SSOT (Single Source of Truth),
/// and there is a desire for a globally accessible state operations, this
/// global key enables that at runtime.
///
/// The limitation of this decision is that the global API will not work in unit
/// tests. However, they will work in Widget/Integration tests assuming you have
/// a DartBoard widget with appropriate features enabled.
///
/// Additionally, you won't be able to put 2 DartBoards in a Row and make a split
/// screen 2 app experience. However, we have other global keys in Dart Board Core
/// already. So this isn't breaking support for that. The decision to trade this
/// esoteric possibility for clean API's for features was already made.
///
/// Those who know Redux know that the framework is not important for unit tests
/// and that unit tests will use 0% of the API I provide above.
/// You are responsible for your State objects and Actions on them,
/// so you can easily write your own unit to verify them.
///
/// Additionally, when using Widget Testing and pumping the DartBoard widget
/// with the correct features, the API will work as expected. So you can write
/// App style dispatches in a test, just has to be an integration test.
final _dartBoardReduxKey = GlobalKey<_DartBoardStoreWidgetState>();
