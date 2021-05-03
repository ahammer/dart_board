import 'package:dart_board_interface/dart_board_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Communicates with Core. For extensions
GlobalKey dartBoardKey = GlobalKey();

/// Shortcuts into DartBoard
abstract class DartBoardCore {
  List<DartBoardExtension> get extensions;
  List<RouteDefinition> get routes;

  static List<DartBoardExtension> getExtensions() =>
      Provider.of<DartBoardCore>(dartBoardKey.currentContext).extensions;

  static List<RouteDefinition> getRoutes() =>
      Provider.of<DartBoardCore>(dartBoardKey.currentContext).routes;
}
