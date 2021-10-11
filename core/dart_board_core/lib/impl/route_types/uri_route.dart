import 'package:flutter/material.dart';

import '../../dart_board_core.dart';

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
