import 'package:dart_board_interface/dart_board_feature.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Communicates with Core. For features
GlobalKey<NavigatorState> dartBoardNavKey = GlobalKey();

/// Dart Board Core
///
/// This is the basic interface into DartBoard
///
/// It stores the Features,
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
  Widget applyPageDecorations(Widget child);

  /// Builds a page route
  ///
  /// This is in the interface
  Widget buildPageRoute(
      BuildContext context, RouteSettings settings, RouteDefinition definition);

  ///------------------------------------------------------------------------------------------------------------
  /// STATIC HELPERS

  static Widget decoratePage(Widget child) =>
      Provider.of<DartBoardCore>(dartBoardNavKey.currentContext!)
          .applyPageDecorations(child);

  /// Helper to get a list of the features
  static List<DartBoardFeature> get featureList =>
      Provider.of<DartBoardCore>(dartBoardNavKey.currentContext!).features;

  /// Helper to find an feature by name
  static DartBoardFeature findByName(String name) =>
      Provider.of<DartBoardCore>(dartBoardNavKey.currentContext!)
          .features
          .firstWhere((element) => element.namespace == name,
              orElse: () => EmptyDartBoardFeature());
}
