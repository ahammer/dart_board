import 'package:dart_board_core/dart_board.dart';
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
  static DartBoardCore get instance =>
      Provider.of<DartBoardCore>(dartBoardNavKey.currentContext!,
          listen: false);

  /// These are the Features
  ///
  /// The implementation is responsible for managing this list

  List<DartBoardDecoration> get pageDecorations;
  List<DartBoardDecoration> get appDecorations;
  List<String> get pageDecorationDenyList;
  List<String> get pageDecorationAllowList;
  Set<String> get whitelistedPageDecorations;
  List<DartBoardFeature> get allFeatures;
  List<RouteDefinition> get routes;

  /// This is all detected implementations for each feature namespace
  Map<String, List<String>> get detectedImplementations;

  /// These are the currently active implementations for each feature
  Map<String, String> get activeImplementations;

  /// These are the RouteDefinitions
  ///
  /// They are exposed for debug/info purposes primarily

  /// Builds a page route
  ///
  Widget buildPageRoute(
      BuildContext context, RouteSettings settings, RouteDefinition definition,
      {bool decorate = true});

  ///------------------------------------------------------------------------------------------------------------
  /// STATIC HELPERS

  /// Finds a Feature by it's name
  DartBoardFeature findByName(String name) =>
      allFeatures.firstWhere((element) => element.namespace == name,
          orElse: () => EmptyDartBoardFeature());

  /// When multiple implementations for a feature are registered
  /// You can change at runtime with this
  ///
  /// Set value == null to disable
  void setFeatureImplementation(String namespace, String? value);

  /// Feature gating
  bool isFeatureActive(String namespace);

  /// Check if this route can be resolved
  bool confirmRouteExists(String route);
}

///
/// This specifies a Page Decoration from an feature
///
/// It comes with methods to decide if it should apply or not.
/// and a name so it can be shown in the debug tools
/// or referenced in allow/deny lists.
class DartBoardDecoration {
  final String name;
  final WidgetWithChildBuilder decoration;

  DartBoardDecoration({required this.name, required this.decoration});

  @override
  String toString() => name;
}

/// An feature class
/// features are hooked up VIA RPC
/// Core feature's are features that are available on the classpath
abstract class DartBoardFeature<T> {
  /// A namespace to prefix to reference this feature by
  /// Please make it unique
  String get namespace => runtimeType.toString();

  // An implementation name, this should be unique for each implementation used
  // When AB testing, share the namespace, make implementationName unique
  // E.g. namespace 'background', implementations: ['background_red', 'background_blue']
  String get implementationName => 'default';

  /// The route definitions
  List<RouteDefinition> get routes => [];

  /// The app decorations (global)
  List<DartBoardDecoration> get appDecorations => [];

  /// The page decorations (page level)
  List<DartBoardDecoration> get pageDecorations => [];

  // Other features this one depends on
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
class EmptyDartBoardFeature extends DartBoardFeature {}
