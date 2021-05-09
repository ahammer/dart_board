import 'package:flutter/widgets.dart';

/// Used to "inject" widgets into the tree.
/// We inject right above/below the nav. E.g. App/Page scope
///
/// It is used for the appDecorations and pageDecorations.
typedef Widget WidgetWithChildBuilder(BuildContext context, Widget child);
typedef RouteWidgetBuilder(BuildContext context, RouteSettings settings);

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
  List<WidgetWithChildBuilder> get pageDecorations => [];

  List<DartBoardExtension> get dependencies => [];

  @override
  String toString() => namespace;
}

abstract class RouteDefinition {
  bool matches(RouteSettings settings);
  RouteWidgetBuilder get builder;
}

class NamedRouteDefinition implements RouteDefinition {
  final String route;
  final RouteWidgetBuilder builder;

  NamedRouteDefinition({@required this.route, @required this.builder});

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
