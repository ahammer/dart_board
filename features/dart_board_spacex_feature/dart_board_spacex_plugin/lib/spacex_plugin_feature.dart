import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_spacex_plugin/spacex_api.dart';
import 'package:dart_board_spacex_repository/impl/spacex_repository.dart';
import 'package:dart_board_spacex_repository/impl/spacex_repository_graphql.dart';
import 'package:flutter/material.dart';
import 'package:dart_board_locator/dart_board_locator.dart';
import 'package:dart_board_spacex_repository/spacex_data_layer_feature.dart';

class SpaceXPluginFeature extends DartBoardFeature {
  @override
  String get namespace => "SpaceX_Add2App";

  @override
  List<DartBoardDecoration> get appDecorations => [
        DartBoardDecoration(
            name: 'SX_Add2App',
            decoration: (ctx, child) => LifeCycleWidget(
                preInit: () => SpaceX.setup(SpaceXBinding()),
                key: const ValueKey("SX_Add2App_LC"),
                child: child))
      ];

  @override
  List<DartBoardFeature> get dependencies =>
      [SpaceXDataLayerFeature(SpaceXRepositoryGraphQL())];
}

class SpaceXBinding extends SpaceX {
  @override
  Future<List<LaunchDataNative>> getLaunches() async =>
      (await locate<SpaceXRepository>().getPastLaunches())!
          .map((e) => LaunchDataNative()..missionName = e?.missionName)
          .toList();
}
