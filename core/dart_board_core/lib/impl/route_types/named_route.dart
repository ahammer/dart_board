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

/// Meant for PathedRoutes
///
/// This will match everything that hits it, and echo it's value into the settings
/// Primarily, this is for like /path/items/321
///
/// where you want "321" in the Settings so you can inflate a page with
/// ID 321
///
/// Since this will match everything, it's recommended to only be used
/// in conjunction with pathed route.
///
class UriRoute implements RouteDefinition {
  final Widget Function(BuildContext, Uri uri) echoBuilder;

  @override
  RouteBuilder? routeBuilder;

  UriRoute(this.echoBuilder);

  @override
  RouteWidgetBuilder get builder =>
      (ctx, settings) => echoBuilder(ctx, Uri.parse(settings.name ?? '/'));

  @override
  bool matches(RouteSettings settings) => true;
}
