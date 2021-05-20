import 'package:dart_board_interface/dart_board_feature.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Communicates with Core. For features
GlobalKey<NavigatorState> dartBoardNavKey = GlobalKey();

/// Shortcuts into DartBoard
abstract class DartBoardCore {
  List<DartBoardFeature> get features;
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

  /// Helper to get a list of the features
  static List<DartBoardFeature> getfeatures() =>
      Provider.of<DartBoardCore>(dartBoardNavKey.currentContext!).features;

  /// Helper to find an feature by name
  static DartBoardFeature findByName(String name) =>
      Provider.of<DartBoardCore>(dartBoardNavKey.currentContext!)
          .features
          .firstWhere((element) => element.namespace == name,
              orElse: () => EmptyDartBoardFeature());
}
