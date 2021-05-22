import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart_board_feature.dart';

/// Communicates with Core. For features
GlobalKey<NavigatorState> dartBoardNavKey = GlobalKey();

/// Dart Board Core
///
/// This is the basic interface into DartBoard
///
/// The core itself doesn't expose many features
/// However, this basic interface will allow extensions
/// to probe into the system. E.g. check if a module or route is active.
///
///
abstract class DartBoardCore {
  /// These are the Features
  ///
  /// The implementation is responsible for managing this list
  List<DartBoardFeature> get features;

  /// These are the RouteDefinitions
  ///
  /// They are exposed for debug/info purposes primarily
  List<RouteDefinition> get routes => features.fold(
      [], (previousValue, element) => [...previousValue, ...element.routes]);

  /// Apply Page Decorations to a widget.
  ///
  /// child:
  ///
  /// E.g. if you use RouteWidget with like a dialog, but want the decorations
  Widget applyPageDecorations(Widget child) => child;

  /// Builds a page route
  ///
  Widget buildPageRoute(
      BuildContext context, RouteSettings settings, RouteDefinition definition);

  ///------------------------------------------------------------------------------------------------------------
  /// STATIC HELPERS

  /// Decorate a page.
  static Widget decoratePage(Widget child) =>
      Provider.of<DartBoardCore>(dartBoardNavKey.currentContext!)
          .applyPageDecorations(child);

  /// Gets a list of all features
  static List<DartBoardFeature> get featureList =>
      Provider.of<DartBoardCore>(dartBoardNavKey.currentContext!).features;

  /// Finds a Feature by it's name
  static DartBoardFeature findByName(String name) =>
      Provider.of<DartBoardCore>(dartBoardNavKey.currentContext!)
          .features
          .firstWhere((element) => element.namespace == name,
              orElse: () => EmptyDartBoardFeature());
}
