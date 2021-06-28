import '../../dart_board.dart';

/// These are ultra-generic Features.
///
/// They can be used for higher level composition.
///

/// A Generic Route Mirroring
/// You can use this to copy a route to a smaller feature, for AB purposes
class MirrorRouteFeature extends DartBoardFeature {
  final String targetRoute;
  final String sourceRoute;

  @override
  final String namespace;
  @override
  final String implementationName;

  MirrorRouteFeature(
      {required this.sourceRoute,
      required this.targetRoute,
      this.namespace = 'mirror_template_feature',
      this.implementationName = 'mirror_template_feature'});

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: targetRoute,
            builder: (ctx, settings) => RouteWidget(sourceRoute))
      ];
}

/// Just installs a widget on a route
class BasicRouteFeature extends DartBoardFeature {
  final String targetRoute;
  final WidgetBuilder builder;
  @override
  final String namespace;
  @override
  final String implementationName;

  BasicRouteFeature(
      {required this.targetRoute,
      required this.builder,
      this.namespace = 'basic_route_feature',
      this.implementationName = 'mirror_template_feature'});

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: targetRoute, builder: (settings, ctx) => builder(ctx))
      ];
}
