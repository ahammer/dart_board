import 'package:dart_board/dart_board.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Interfaces for Dart Board
///
/// - Global Key used by navigator
///   (gives an app-state friendly context, and access to the Navigator)
///
/// - Typedefs used by the Extensions

/// Communicates with Core. For features
GlobalKey<NavigatorState> dartBoardNavKey = GlobalKey();

typedef WidgetWithChildBuilder = Widget Function(
    BuildContext context, Widget child);

/// Builds a widget for a route
typedef RouteWidgetBuilder = Widget Function(
    RouteSettings settings, BuildContext context);

/// Builds a Route itself (e.g. MaterialPageRoute, CupertinoPageRoute or other)
typedef RouteBuilder = Route Function(
    RouteSettings settings, WidgetBuilder builder);

/// Dart Board Core Interfaces
///
///
/// These are the main interface/objects used in DartBoard
///
/// API Changes
/// - New named parameters OK
/// - New functions OK
/// - Change interface NO
///
/// Backwards compatibility is #1
///
/// When working with DartBoard, use these interfaces to access it.
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
      BuildContext context, RouteSettings settings, RouteDefinition definition,
      {bool decorate = true});

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

extension DartBoardFeatureListExtension on List<DartBoardFeature> {
  List<NamedRouteDefinition> get namedRoutes => fold<List<RouteDefinition>>(
      <RouteDefinition>[],
      (previousValue, element) => <RouteDefinition>[
            ...previousValue,
            ...element.routes
          ]).whereType<NamedRouteDefinition>().toList();
}

///
/// This specifies a Page Decoration from an feature
///
/// It comes with methods to decide if it should apply or not.
/// and a name so it can be shown in the debug tools
/// or referenced in allow/deny lists.
class PageDecoration {
  final String name;
  final WidgetWithChildBuilder decoration;

  PageDecoration({required this.name, required this.decoration});

  @override
  String toString() => name;
}

/// An feature class
/// features are hooked up VIA RPC
/// Core feature's are features that are available on the classpath
abstract class DartBoardFeature<T> {
  /// A namespace to prefix to reference this feature by
  /// Please make it unique
  String get namespace;

  /// The route definitions
  List<RouteDefinition> get routes => [];

  /// The app decorations (global)
  List<WidgetWithChildBuilder> get appDecorations => [];

  /// The page decorations (page level)
  List<PageDecoration> get pageDecorations => [];

  List<DartBoardFeature> get dependencies => [];

  /// Deny list for page decorations in the format
  /// "/route:page_decoration_name"
  ///
  /// Useful when you don't want a decoration on a page
  /// Normally provided in the integration feature
  List<String> get pageDecorationDenyList => [];

  /// Allow list for page decorations in the format
  /// "/route:page_decoration_name"
  ///
  /// Userful when you want a page decoration on a specific
  /// set of pages
  ///
  /// If the allow list is used for a decoration, the deny list is ignored
  /// E.g. if the Same entry is in both lists, Allow takes priority
  /// Having one entry in allow is the same as having
  /// a deny for everything else.
  List<String> get pageDecorationAllowList => [];

  @override
  String toString() => namespace;
}

abstract class RouteDefinition {
  /// If this route definition matches a RouteSettings object
  bool matches(RouteSettings settings);

  /// This is the builder for the content
  RouteWidgetBuilder get builder;

  ///This is an optional RouteBuilder
  RouteBuilder? routeBuilder;
}

/// An empty feature to use as a default if an feature can't be found
class EmptyDartBoardFeature extends DartBoardFeature {
  @override
  String get namespace => 'Emptyfeature';
}
