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
    runApp(DartBoard(initialRoute: '/example', features: [ExampleLocator()]));

class ExampleState extends ChangeNotifier {
  int count;
  ExampleState({this.count = 123});

  void increment() {
    count++;
    notifyListeners();
  }

  @override
  String toString() => "ExampleState($count)";
}

class ExampleLocator extends DartBoardFeature {
  /// All features have a namespace, it should be unique "per feature"
  @override
  String get namespace => "redux_example";

  /// We provide a route here, "/example"
  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: "/example", builder: (ctx, settings) => LocatorScreen())
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

class LocatorScreen extends StatefulWidget {
  @override
  _LocatorScreenState createState() => _LocatorScreenState();
}

class _LocatorScreenState extends State<LocatorScreen> {
  late ExampleState state;
  @override
  void initState() {
    super.initState();
    state = locate();
    state.addListener(onChange);
  }

  /// On change's let's set state
  void onChange() => setState(() {});

  @override
  void dispose() {
    state.removeListener(onChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("hello: ${state.count}"),
          MaterialButton(
            onPressed: () {
              /// Can also use like this
              locate<ExampleState>().increment();
            },
            child: Text("Press Me"),
          )
        ],
      ),
    ));
  }
}
