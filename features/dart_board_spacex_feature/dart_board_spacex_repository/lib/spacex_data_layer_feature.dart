import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_locator/dart_board_locator.dart';
import 'package:flutter/material.dart';
import 'package:dart_board_spacex_repository/impl/spacex_repository.dart';

class SpaceXDataLayerFeature extends DartBoardFeature {
  final SpaceXRepository repository;

  /// Give it a repository to actually fetch the data
  SpaceXDataLayerFeature(this.repository);

  @override
  String get namespace => "SpaceXRepositoryFeature";

  @override
  List<DartBoardDecoration> get appDecorations => [
        LocatorDecoration(() => repository),
      ];

  @override
  List<DartBoardFeature> get dependencies => [DartBoardLocatorFeature()];
}
