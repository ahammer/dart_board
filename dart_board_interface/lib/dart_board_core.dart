import 'package:dart_board_interface/dart_board_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Communicates with Core. For extensions
GlobalKey<NavigatorState> dartBoardNavKey = GlobalKey();

/// Shortcuts into DartBoard
abstract class DartBoardCore {
  List<DartBoardExtension> get extensions;
  List<RouteDefinition> get routes;
  Widget applyPageDecorations(Widget child);
  Widget buildPageRoute(
      BuildContext context, RouteSettings settings, RouteDefinition definition);

  static Widget decoratePage(Widget child, {RouteSettings settings}) =>
      Provider.of<DartBoardCore>(dartBoardNavKey.currentContext)
          .applyPageDecorations(child);

  static List<DartBoardExtension> getExtensions() =>
      Provider.of<DartBoardCore>(dartBoardNavKey.currentContext).extensions;

  static List<RouteDefinition> getRoutes() =>
      Provider.of<DartBoardCore>(dartBoardNavKey.currentContext).routes;

  static DartBoardExtension findByName(String name) =>
      Provider.of<DartBoardCore>(dartBoardNavKey.currentContext)
          .extensions
          .firstWhere((element) => element.namespace == name);
}
