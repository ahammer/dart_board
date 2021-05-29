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