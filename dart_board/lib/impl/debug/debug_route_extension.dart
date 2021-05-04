import 'package:dart_board_interface/dart_board_extension.dart';
import 'package:flutter/material.dart';

class DebugRouteExtension implements DartBoardExtension {
  @override
  get appDecorations => [];

  @override
  get pageDecorations => [];

  @override
  get routes =>
      <RouteDefinition>[]..addMap({"/debug": (context) => DebugScreen()});
}

class DebugScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(child: Text("Debug Screen"));
}
