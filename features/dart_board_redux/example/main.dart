import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_redux/dart_board_redux.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

/// ----------------------------------------------------------------------------
///                             Dart Board Redux Example
///
/// Goals: To create a Redux State, and then modify it in a variety of practical
/// ways.
///
/// 1) Dispatch Actions
/// 2) Use Middleware
/// 3) Listen to Changes
///
/// To do this, we'll create an Example Extension with a UI route
/// We'll also provide a Redux State and some Middleware
/// Add buttons that dispatch actions/manipulate state
///
/// Finally, we'll use the State Listener widget to update

/// Our entry point, Starts DartBoard at the /example route
void main() =>
    runApp(DartBoard(initialPath: '/example', features: [ExampleRedux()]));

/// Since this is a Redux Example, lets first share our state/actions and epics
///
class ExampleState {
  final int count;
  ExampleState({this.count = 0});
  @override
  String toString() => "ExampleState($count)";
}

/// We can do our Actions as Functions
ExampleState increment(ExampleState oldState) =>
    ExampleState(count: oldState.count + 1);

/// We can bundle our Actions as ReduxAction<Type>
class IncrementAction extends FeatureAction<ExampleState> {
  @override
  ExampleState featureReduce(ExampleState state) =>
      ExampleState(count: state.count + 1);
}

/// Demonstrate a epic that delays an increment
///
/// This would be used to hook up network calls
/// or other long running operations

Stream<dynamic> delayedIncrementEpic(
        Stream<dynamic> actions, EpicStore<DartBoardState> store) =>
    actions
        .whereType<DelayedIncrement>()
        .debounceTime(Duration(milliseconds: 400))
        .asyncMap((action) => Future.delayed(Duration(seconds: 1))
            .then((results) => IncrementAction()));

/// Type Marker for a Async Epic
class DelayedIncrement {}

/// Our example features
class ExampleRedux extends DartBoardFeature {
  /// All features have a namespace, it should be unique "per feature"
  @override
  String get namespace => "redux_example";

  /// We provide a route here, "/example"
  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: "/example", builder: (ctx, settings) => ReduxScreen())
      ];

  /// We provide our Redux State Object (ExampleState) as an App Decoration
  /// We also provide an Epic, delayedIncrementEpic that debounces
  /// the action so you mash the button but only get an action when you stop
  @override
  List<DartBoardDecoration> get appDecorations => [
        /// This is our State object
        ReduxStateDecoration<ExampleState>(
            factory: () => ExampleState(count: 0), name: "ExampleReduxState"),

        /// This is our middleware (Epic) for the async debouncer
        ReduxMiddlewareDecoration(
            name: "ButtonDebouncerEpic",
            middleware: EpicMiddleware(delayedIncrementEpic))
      ];

  @override
  List<DartBoardFeature> get dependencies => [DartBoardRedux()];
}

/// The actual UI
///
/// It's 3 buttons + a Text View
///
/// The entire thing is wrapped in a FeatureStateBuilder<ExampleState>
///
/// It Dispatches via 3 different methods
/// 1) Using the Class Method
/// 2) Using the Functional Method
/// 3) Indirectly, via Epic
///
/// It illustrate state changes by altering border/colors
/// and updating the count.
///
/// Animation handled by a simple AnimatedContainer
class ReduxScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
          body: Center(
        child: FeatureStateBuilder<ExampleState>(
          (ctx, state) => AnimatedContainer(
            decoration: BoxDecoration(
                color: state.count % 2 == 0
                    ? Colors.lightBlueAccent
                    : Colors.lightGreenAccent,
                borderRadius: BorderRadius.circular((state.count % 5) * 15)),
            duration: Duration(milliseconds: 200),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Count: ${state.count}"),
                  MaterialButton(
                    elevation: 2,

                    ///---------------------- OBJECT DISPATCH
                    onPressed: () => dispatch(IncrementAction()),
                    child: Text("Increment Object"),
                  ),
                  MaterialButton(
                    elevation: 2,

                    ///---------------------- FUNCTION DISPATCH
                    onPressed: () => dispatchFunc(increment),
                    child: Text("Functional Dispatch"),
                  ),
                  MaterialButton(
                    elevation: 2,

                    ///---------------------- EPIC HOOK
                    onPressed: () => dispatch(DelayedIncrement()),
                    child: Text("Debounced Epic"),
                  ),
                ],
              ),
            ),
          ),
          distinct: true,
        ),
      ));
}
