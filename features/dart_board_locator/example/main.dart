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

class ExampleLocator extends DartBoardFeature {
  /// All features have a namespace, it should be unique "per feature"
  @override
  String get namespace => "redux_example";

  /// We provide a route here, "/example"
  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: "/example",
            builder: (ctx, settings) => Row(
                  children: [
                    Expanded(
                        child: LocatorDemo(
                      instance_id: "Instance 1",
                    )),
                    Expanded(
                        child: LocatorDemo(
                      instance_id: "Instance 2",
                    )),
                  ],
                ))
      ];

  /// We provide our Redux State Object (ExampleState) as an App Decoration
  /// We also provide an Epic, delayedIncrementEpic that debounces
  /// the action so you mash the button but only get an action when you stop
  @override
  List<DartBoardDecoration> get appDecorations =>
      [LocatorDecoration(() => ExampleState())];

  @override
  List<DartBoardFeature> get dependencies => [DartBoardLocatorFeature()];
}

/// This is our State object
///
/// We'll use a ChangeNotifier and hook it up to a StatefulWidget
///
class ExampleState extends ChangeNotifier {
  int _count = 1;
  ExampleState();

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  @override
  String toString() => "ExampleState($count)";
}

/// The Locator Demo Screen
///
/// We'll show a count and have a button to modify state
class LocatorDemo extends StatefulWidget {
  final String instance_id;

  const LocatorDemo({Key? key, this.instance_id = ""}) : super(key: key);
  @override
  _LocatorDemoState createState() => _LocatorDemoState();
}

/// We are going to bind this State to the ChangeNotifier based state
class _LocatorDemoState extends State<LocatorDemo> {
  late ExampleState state;

  /// On change's let's set state
  void onChange() => setState(() {});

  @override
  void initState() {
    super.initState();
    state = locate(instance_id: widget.instance_id)..addListener(onChange);
  }

  @override
  void dispose() {
    state.removeListener(onChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
          body: Center(
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.instance_id),
              Divider(),
              Text("hello: ${state.count}"),
              MaterialButton(
                onPressed: () {
                  /// Can also use like this
                  locate<ExampleState>(instance_id: widget.instance_id)
                      .increment();
                },
                child: Text("Press Me"),
              )
            ],
          ),
        ),
      ));
}
