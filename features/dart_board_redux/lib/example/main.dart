import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_redux/dart_board_redux.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

/// Loading up the Example Extension + Redux
void main() =>
    runApp(DartBoard(initialRoute: '/example', features: [ExampleRedux()]));

class ExampleRedux extends DartBoardFeature {
  @override
  String get namespace => "Redux Example";

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: "/example", builder: (ctx, settings) => ReduxScreen())
      ];

  @override
  List<DartBoardDecoration> get appDecorations => [
        /// This is our State object
        ReduxStateDecoration<ExampleState>(
            factory: () => ExampleState(count: 0), name: "ExampleReduxState"),

        /// This is our middleware (Epic)
        ReduxMiddlewareDecoration(
            name: "ButtonDebouncerEpic",
            middleware: EpicMiddleware(delayedIncrementEpic))
      ];

  @override
  List<DartBoardFeature> get dependencies => [DartBoardRedux()];
}

class ReduxScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ReduxBuilder<ExampleState>(
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
                  onPressed: () => dispatch(IncrementAction()),
                  child: Text("Increment Object"),
                ),
                MaterialButton(
                  elevation: 2,
                  onPressed: () => dispatchFunc(increment),
                  child: Text("Functional Dispatch"),
                ),
                MaterialButton(
                  elevation: 2,
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
}

class ExampleState {
  final int count;
  ExampleState({this.count = 0});
  @override
  String toString() => "ExampleState($count)";
}

/// Type Marker for a Async Epic
class DelayedIncrement {}

/// We can do our Actions as Functions
ExampleState increment(ExampleState oldState) =>
    ExampleState(count: oldState.count + 1);

/// We can bundle our Actions as ReduxAction<Type>
class IncrementAction extends ReduxAction<ExampleState> {
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
