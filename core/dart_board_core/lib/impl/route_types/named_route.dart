import 'package:flutter/material.dart';

import '../../dart_board.dart';

/// This an implementation of the RouteDefinition class
///
/// Can be used for simple named routing
///
/// E.g. NamedRouteDefinition(route: "main", builder: (ctx, settings)=>Container(...))
class NamedRouteDefinition implements RouteDefinition {
  /// The Route this NamedRoute maps to
  /// E.g. /main
  final String route;

  /// The builder for the screen, bringing in the settings from the route
  /// e.g. (ctx, setting) => nil
  @override
  final RouteWidgetBuilder builder;

  /// An optional routeBuilder over-ride
  /// This is if you want to control the page transitions.
  ///
  /// E.g. kCupertinoPageRouteResolver or kMaterialPageRouteResolver
  ///
  /// You can also use this to implement custom transitions for a route
  /// e.g. a fade or a slide.
  @override
  RouteBuilder? routeBuilder;

  NamedRouteDefinition(
      {required this.route, required this.builder, this.routeBuilder});

  @override
  bool matches(RouteSettings settings) => settings.name == route;

  @override
  String toString() => route;
}
