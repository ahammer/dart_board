import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_space_scene/space_scene_feature.dart';
import 'package:dart_board_theme/dart_board_theme.dart';
import 'package:flutter/material.dart';
import 'package:spacex_launch_repository/impl/spacex_repository.dart';
import 'package:spacex_launch_repository/impl/spacex_repository_graphql.dart';
import 'package:spacex_launch_repository/spacex_data_layer_feature.dart';
import 'package:dart_board_locator/dart_board_locator.dart';
import 'package:intl/intl.dart';

import 'ui/launch_screen.dart';
import 'ui/past_launch_list.dart';

void main() => runApp(DartBoard(
      features: [
        SpaceXUIFeature(),
        SpaceSceneFeature(),
        ThemeFeature(isDarkByDefault: true)
      ],
      initialRoute: '/launches',
    ));

/// Feature with the UI registration
class SpaceXUIFeature extends DartBoardFeature {
  @override
  String get namespace => "spaceXUI";

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: '/launches', builder: (ctx, settings) => LaunchScreen())
      ];

  @override
  List<DartBoardDecoration> get appDecorations =>
      [LocatorDecoration(() => LaunchScreenState())];

  @override
  List<DartBoardFeature> get dependencies => [
        SpaceXDataLayerFeature(SpaceXRepositoryGraphQL()),
        DartBoardLocatorFeature()
      ];
}
