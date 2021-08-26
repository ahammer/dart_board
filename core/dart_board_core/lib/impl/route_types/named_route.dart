import 'package:flutter/material.dart';

import '../../dart_board.dart';

/// This an implementation of the RouteDefinition class
///
/// Can be used for simple named routing
///
/// E.g. NamedRouteDefinition(route: "/main", builder: (ctx, settings)=>Container(...))

class NamedRouteDefinition implements RouteDefinition {
  /// The Route this NamedRoute maps to
  /// E.g. /main
  final String route;

  /// The builder for the screen, bringing in the settings from the route
  /// e.g. (ctx, setting) => Container()
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
      (ctx, settings) => routeMap[settings.name]!(ctx, settings);
}

/// This one should take map of name->builder
/// Want a NamedRouteDefinition for maps
///
//class MappedRoutesDefinition implements RouteDefinition {}
