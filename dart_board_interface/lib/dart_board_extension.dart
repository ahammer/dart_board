import 'package:flutter/widgets.dart';

/// Dart Board Extension and Related interfaces.
///
/// This interface is the preferable way to create Extension's for
/// the Dart-Board framework.
///
/// This API will remain frozen between major versions
/// It should provide all the basics for interacting with the framework.
/// The stability of this API should ensure the stability of extensions
/// targeting the platform.
///
/// It's suggested that when developing an extension, that you bring it into
/// a "runner"/example project that can bring in DartBoard and include it in the main()

/// Builds a widget with a predetermined child
/// Used by App/Page decorators.
typedef Widget WidgetWithChildBuilder(BuildContext context, Widget child);

/// Builds a widget for a route
typedef Widget RouteWidgetBuilder(RouteSettings settings, BuildContext context);

///
/// This specifies a Page Decoration from an extension
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

/// An extension class
/// Extensions are hooked up VIA RPC
/// Core Extension's are extensions that are available on the classpath
abstract class DartBoardExtension<T> {
  /// A namespace to prefix to reference this extension by
  /// Please make it unique
  String get namespace;

  /// The route definitions
  List<RouteDefinition> get routes => [];

  /// The app decorations (global)
  List<WidgetWithChildBuilder> get appDecorations => [];

  /// The page decorations (page level)
  List<PageDecoration> get pageDecorations => [];

  List<DartBoardExtension> get dependencies => [];

  /// Blacklists for page decorations in the format
  /// "/route:page_decoration_name"
  ///
  /// Useful when you don't want a decoration on a page
  /// Normally provided in the integration extension
  List<String> get pageDecorationDenyList => [];
  @override
  String toString() => namespace;
}

abstract class RouteDefinition {
  /// If this route definition matches a RouteSettings object
  bool matches(RouteSettings settings);

  /// This is the builder for the content
  RouteWidgetBuilder get builder;

  ///This is an optional RouteBuilder
  Route Function(RouteSettings settings, WidgetBuilder builder)? routeBuilder;
}

/// This an implementation of the RouteDefinition class
///
/// Can be used for simple named routing
class NamedRouteDefinition implements RouteDefinition {
  final String route;
  final RouteWidgetBuilder builder;
  Route Function(RouteSettings settings, WidgetBuilder builder)? routeBuilder;

  NamedRouteDefinition(
      {required this.route, required this.builder, this.routeBuilder});

  @override
  bool matches(RouteSettings settings) => settings.name == route;

  @override
  String toString() => route;
}

/// Syntactic Sugar
/// Extension for <RouteDefinition>[] to add a map of "string" => Builder
extension DartBoardRouteListExtension on List<RouteDefinition> {
  /// Helper to specify these as a map
  void addMap(Map<String, RouteWidgetBuilder> items) =>
      items.forEach((route, builder) =>
          add(NamedRouteDefinition(route: route, builder: builder)));
}
