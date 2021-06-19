import '../../dart_board.dart';

/// This an implementation of the RouteDefinition class
///
/// Can be used for simple named routing
class NamedRouteDefinition implements RouteDefinition {
  final String route;

  @override
  final RouteWidgetBuilder builder;

  @override
  RouteBuilder? routeBuilder;

  NamedRouteDefinition(
      {required this.route, required this.builder, this.routeBuilder});

  @override
  bool matches(RouteSettings settings) => settings.name == route;

  @override
  String toString() => route;
}

/// Defines routes in a map format
class MapRouteDefinition implements RouteDefinition {
  final Map<String, RouteWidgetBuilder> routeMap;

  MapRouteDefinition({required this.routeMap, this.routeBuilder});

  @override
  bool matches(RouteSettings settings) => routeMap.containsKey(settings.name);

  @override
  RouteBuilder? routeBuilder;

  @override
  RouteWidgetBuilder get builder =>
      (settings, ctx) => routeMap[settings.name]!(settings, ctx);
}
/// This one should take map of name->builder
/// Want a NamedRouteDefinition for maps
/// 
//class MappedRoutesDefinition implements RouteDefinition {}
