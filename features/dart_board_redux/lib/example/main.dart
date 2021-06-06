import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_redux/dart_board_redux.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

/// Simple minesweep runner
void main() =>
    runApp(DartBoard(initialRoute: '/redux', features: [ExampleRedux()]));

class ExampleRedux extends DartBoardFeature {
  @override
  String get namespace => "Redux Example";

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: "/redux", builder: (ctx, settings) => ReduxScreen())
      ];

  @override
  List<DartBoardDecoration> get appDecorations => [
        ReduxStateProviderDecoration<ExampleState>(
            factory: () => ExampleState(count: 0), name: "Example Redux State"),
        ReduxMiddlewareProviderDecoration(
            name: "ExampleEpic",
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
      child: ReduxStateUpdater<ExampleState>(
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
                  onPressed: () => dispatch(DelayedIncrement()),
                  child: Text("Increment vis Async Epic"),
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

ExampleState increment(ExampleState oldState) =>
    ExampleState(count: oldState.count + 1);

class IncrementAction extends FeatureReducable<ExampleState> {
  @override
  ExampleState featureReduce(ExampleState state) =>
      ExampleState(count: state.count + 1);
}

Stream<dynamic> delayedIncrementEpic(
    Stream<dynamic> actions, EpicStore<DartBoardState> store) {
  // Wrap our actions Stream as an Observable. This will enhance the stream with
  // a bit of extra functionality.
  return actions
      // Use `whereType` to narrow down to PerformSearchAction
      .whereType<DelayedIncrement>()
      .asyncMap((action) =>
          // No need to cast the action to extract the search term!
          Future.delayed(Duration(seconds: 1))
              .then((results) => IncrementAction()));
}
