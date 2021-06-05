import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_redux/dart_board_redux.dart';
import 'package:flutter/material.dart';

/// Simple minesweep runner
void main() => runApp(DartBoard(
    initialRoute: '/redux', features: [DartBoardRedux(), ExampleRedux()]));

class ExampleRedux extends DartBoardFeature {
  @override
  String get namespace => "Redux Example";

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: "/redux", builder: (ctx, settings) => ReduxScreen())
      ];
}

class ReduxScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Count: 0"),
        MaterialButton(
          elevation: 2,
          onPressed: () => dispatch(increment),
          child: Text("Increment"),
        )
      ],
    )));
  }
}

class ExampleState {
  final int count;
  ExampleState({this.count = 0});
}

ExampleState increment(ExampleState oldState) =>
    ExampleState(count: oldState.count + 1);
