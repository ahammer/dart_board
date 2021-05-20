import 'package:dart_board_interface/dart_board_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Communicates with Core. For extensions
GlobalKey<NavigatorState> dartBoardNavKey = GlobalKey();

/// Shortcuts into DartBoard
abstract class DartBoardCore {
  List<DartBoardExtension> get extensions;
  List<RouteDefinition> get routes;

  /// Apply the page decorations manually to a widget
  Widget applyPageDecorations(Widget child);

  /// Build a page route based on a RouteDefinition and Settings
  Widget buildPageRoute(
      BuildContext context, RouteSettings settings, RouteDefinition definition);

  /// Helper to decorate a page
  static Widget decoratePage(Widget child) =>
      Provider.of<DartBoardCore>(dartBoardNavKey.currentContext!)
          .applyPageDecorations(child);

  /// Helper to get a list of the extensions
  static List<DartBoardExtension> getExtensions() =>
      Provider.of<DartBoardCore>(dartBoardNavKey.currentContext!).extensions;

  /// Helper to find an extension by name
  static DartBoardExtension findByName(String name) =>
      Provider.of<DartBoardCore>(dartBoardNavKey.currentContext!)
          .extensions
          .firstWhere((element) => element.namespace == name,
              orElse: () => EmptyDartBoardExtension());
}
