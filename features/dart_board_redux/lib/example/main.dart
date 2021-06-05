import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_redux/dart_board_redux.dart';
import 'package:flutter/material.dart';

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
            factory: () => ExampleState(count: 0), name: "Example Redux State")
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
                  onPressed: () => dispatch<ExampleState>(increment),
                  child: Text("Increment Function"),
                ),
                MaterialButton(
                  elevation: 2,
                  onPressed: () => dispatch<ExampleState>(IncrementAction()),
                  child: Text("Increment Object"),
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

ExampleState increment(ExampleState oldState) =>
    ExampleState(count: oldState.count + 1);

class IncrementAction extends Reducable<ExampleState> {
  @override
  ReductionDelegate<ExampleState> get reduce =>
      (state) => ExampleState(count: state.count + 1);
}
