import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_space_scene/space_scene_feature.dart';
import 'package:dart_board_theme/dart_board_theme.dart';
import 'package:flutter/material.dart';
import 'package:spacex_ui/spacex_ui_feature.dart';

void main() => runApp(DartBoard(
      features: [
        SpaceXUIFeature(),
        SpaceSceneFeature(),
        ThemeFeature(data: ThemeData.dark())
      ],
      initialRoute: '/launches',
    ));
