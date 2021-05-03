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

abstract class RouteDefinition {
  bool matches(RouteSettings settings);
  WidgetBuilder get builder;
}

class NamedRouteDefinition implements RouteDefinition {
  final String route;
  final WidgetBuilder builder;

  NamedRouteDefinition({@required this.route, @required this.builder});

  @override
  bool matches(RouteSettings settings) => settings.name == route;
}

/// Syntactic Sugar
/// Extension for <RouteDefinition>[] to add a map of "string" => Builder
extension DartBoardRouteListExtension on List<RouteDefinition> {
  /// Helper to specify these as a map
  void addMap(Map<String, WidgetBuilder> items) =>
      items.forEach((route, builder) =>
          add(NamedRouteDefinition(route: route, builder: builder)));
}
