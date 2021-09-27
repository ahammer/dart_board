import 'package:flutter/material.dart';

import '../../dart_board.dart';

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
