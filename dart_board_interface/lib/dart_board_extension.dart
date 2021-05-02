import 'package:flutter/widgets.dart';

/// An extension class
/// Extensions are hooked up VIA RPC
/// Core Extension's are extensions that are available on the classpath

abstract class DartBoardExtension {
  /// The route builders
  List<RouteDefinition> get routes => [];

  List<WidgetWithChildBuilder> get pageDecorations => [];
}

typedef Widget WidgetWithChildBuilder(BuildContext context, Widget child);

class RouteDefinition {
  final String route;
  final WidgetBuilder builder;

  RouteDefinition({@required this.route, @required this.builder});
}

extension DartBoardRouteListExtension on List<RouteDefinition> {
  /// Helper to specify these as a map
  void addMap(Map<String, WidgetBuilder> items) => items.forEach(
      (route, builder) => add(RouteDefinition(route: route, builder: builder)));
}
