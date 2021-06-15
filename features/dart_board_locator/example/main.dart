import 'package:dart_board_core/dart_board.dart';
import 'package:flutter/material.dart';
import 'package:dart_board_locator/dart_board_locator.dart';

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
    runApp(DartBoard(initialRoute: '/example', features: [ExampleRedux()]));

class ExampleState {
  final int count;
  ExampleState({this.count = 123});
  @override
  String toString() => "ExampleState($count)";
}

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
        LocatorDecoration<ExampleState>(
            name: "example_state", builder: () => ExampleState())
      ];

  @override
  List<DartBoardFeature> get dependencies => [DartBoardLocatorFeature()];
}

class ReduxScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ExampleState state = locate();

    return Scaffold(
        body: Center(
      child: Text("hello: ${state.count}"),
    ));
  }
}
