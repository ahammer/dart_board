import 'package:dart_board/dart_board.dart';
import 'package:dart_board_interface/dart_board_extension.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(DartBoard(
    extensions: [ExampleExtension()],
    home: MyHomePage(),
  ));
}

class ExampleExtension implements DartBoardExtension {
  @override
  get routes => <RouteDefinition>[]..addMap({
      "/hello_world": (ctx) => Text("Welcome to the Example"),
      "/hello_world_2": (ctx) => Text("Welcome to the Example2")
    });

  @override
  get pageDecorations => <WidgetWithChildBuilder>[
        (context, child) => Scaffold(
            drawer: Drawer(
              child: Column(
                children: [
                  MaterialButton(
                    child: Text("Go to /hello_word"),
                    onPressed: () {
                      Navigator.of(context).pushNamed("/hello_world");
                    },
                  ),
                  MaterialButton(
                    child: Text("Go to /hello_word_2"),
                    onPressed: () {
                      Navigator.of(context).pushNamed("/hello_world_2");
                    },
                  )
                ],
              ),
            ),
            appBar: AppBar(title: Text("Example App")),
            body: child),
        (context, child) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                  child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: child,
              )),
            )
      ];
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
          body: Center(
              child: MaterialButton(
        child: Text("Go to /hello_word"),
        onPressed: () {
          Navigator.of(context).pushNamed("/hello_world");
        },
      )));
}
