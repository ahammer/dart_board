import 'package:dart_board_interface/dart_board_extension.dart';
import 'package:flutter/material.dart';

/// This Extension is meant to expose the /Debug route,
/// that should expose information about the extensions
class DebugRouteExtension implements DartBoardExtension {
  @override
  get appDecorations => [];

  @override
  get pageDecorations => [];

  @override
  get routes => <RouteDefinition>[]
    ..addMap({"/debug": (context, settings) => DebugScreen()});
}

class DebugScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(child: DebugPanel(title: "Extensions")),
          Expanded(child: DebugPanel(title: "Details")),
          Expanded(child: DebugPanel(title: "Routes")),
        ],
      );
}

class DebugPanel extends StatelessWidget {
  final String title;
  const DebugPanel({
    @required this.title,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
          height: double.infinity,
          child: Material(
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(title),
              ))),
    );
  }
}
