import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_locator/dart_board_locator.dart';
import 'package:spacex_launch_repository/impl/spacex_repository_graphql.dart';
import 'package:spacex_launch_repository/spacex_data_layer_feature.dart';
import 'ui/launch_screen.dart';

/// Feature with the UI registration
class SpaceXUIFeature extends DartBoardFeature {
  @override
  String get namespace => "spaceXUI";

  @override
  List<RouteDefinition> get routes => [
        PathedRouteDefinition([
          [
            NamedRouteDefinition(
                route: '/launches', builder: (ctx, settings) => LaunchScreen())
          ]
        ]),
      ];

  @override
  List<DartBoardFeature> get dependencies => [
        SpaceXDataLayerFeature(SpaceXRepositoryGraphQL()),
        DartBoardLocatorFeature()
      ];
}
