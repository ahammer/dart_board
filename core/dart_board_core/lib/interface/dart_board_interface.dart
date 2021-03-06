import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'nav_interface.dart';

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
    BuildContext context, RouteSettings settings);

/// Builds a Route itself (e.g. MaterialPageRoute, CupertinoPageRoute or other)
typedef RouteBuilder = Route Function(
    RouteSettings settings, WidgetBuilder builder);

typedef MethodCallHandler = Future Function(
    BuildContext context, MethodCall call);

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
  /// Call this in your constructor to set the instance.
  void initCore() {
    _instance = this;
  }

  static late DartBoardCore _instance;

  /// Quick and dirty getters
  static DartBoardCore get instance => _instance;
  static DartBoardNav get nav => _instance.routerDelegate as DartBoardNav;

  /// Page Decorations and allow/deny list
  List<DartBoardDecoration> get pageDecorations;
  List<String> get pageDecorationDenyList;
  List<String> get pageDecorationAllowList;

  /// We track specifically "white listed" page decorations
  /// Since they prefer whitelist to deny list.
  Set<String> get whitelistedPageDecorations;

  /// Loaded App Decortations
  List<DartBoardDecoration> get appDecorations;

  /// Loaded Method Handlers
  Map<String, MethodCallHandler> get methodHandlers;

  /// All Features registered
  List<DartBoardFeature> get allFeatures;

  /// All features loaded (active)
  Set<DartBoardFeature> get loadedFeatures;

  /// All features specified in the Widget (no dependencies)
  List<DartBoardFeature> get initialFeatures;

  /// All Available Route Definitions
  List<RouteDefinition> get routes;

  /// The Router Delegate (I may let you swap this for custom nav 2.0 implementations)
  RouterDelegate get routerDelegate;

  /// This is all detected implementations for each feature namespace
  Map<String, List<String>> get detectedImplementations;

  /// These are the currently active implementations for each feature
  Map<String, String> get activeImplementations;

  /// Builds a Page based on settings/definition/context
  /// Optionally decorates that page.
  ///
  /// Generally use (RouteWidget()) to access this.
  Widget buildPageRoute(
      BuildContext context, RouteSettings settings, RouteDefinition definition,
      {bool decorate = true});

  /// Finds a Feature by it's name
  DartBoardFeature findByName(String name) =>
      allFeatures.firstWhere((element) => element.namespace == name,
          orElse: () => EmptyDartBoardFeature());

  /// When multiple implementations for a feature are registered
  /// You can change at runtime with this
  ///
  /// Set value == null to disable
  void setFeatureImplementation(String namespace, String? value);

  /// Check if a feature is loaded/active (i.e running right now)
  bool isFeatureActive(String namespace);

  /// Check if this route can be resolved
  bool confirmRouteExists(String route);

  /// Send a method call to be picked up by a feature
  ///
  /// Helper for deep decoupling of features.
  ///
  /// param: context - Current context (to be passed to the handler)
  /// param: call - A MethodCall object (with name and settings) to call out to
  Future<dynamic> dispatchMethodCall(
      {required BuildContext context, required MethodCall call});
}

///
/// This specifies a Page Decoration from an feature
///
/// It comes with methods to decide if it should apply or not.
/// and a name so it can be shown in the debug tools
/// or referenced in allow/deny lists.
class DartBoardDecoration {
  final bool enabled;
  final String name;
  final WidgetWithChildBuilder decoration;

  DartBoardDecoration(
      {required this.name, required this.decoration, this.enabled = true});

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

  /// This can be used to allow an extension to exclude itself.
  /// E.g. Based on platform
  bool get enabled => true;

  /// This is a hint if a feature is "Integration" or not.
  /// The only difference here is that "Integration" features
  /// are not displayed in the dependency graph
  /// (to many edges, looks ugly)

  bool get isIntegrationFeature => false;

  /// This map of method handlers can be used to define callbacks
  ///
  /// context will be the BuildContext where this is invoked from
  ///
  /// call is the actual call (can contain arguments).
  ///
  Map<String, MethodCallHandler> get methodHandlers => {};

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
  String get namespace => 'Empty';
}

/// Warning, unchecked cast
T findByName<T extends DartBoardFeature>(String name) =>
    DartBoardCore.instance.findByName(name) as T;

extension DartBoardCoreContextExtensions on BuildContext {
  void dispatchMethod(String name, [Map<String, dynamic>? args]) =>
      DartBoardCore.instance
          .dispatchMethodCall(context: this, call: MethodCall(name, args));
}
