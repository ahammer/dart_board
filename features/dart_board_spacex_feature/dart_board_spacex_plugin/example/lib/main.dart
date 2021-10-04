import 'package:dart_board_spacex_plugin/spacex_plugin_feature.dart';
import 'package:flutter/material.dart';
import 'package:dart_board_core/dart_board.dart';

void main() {
  runApp(DartBoard(
    features: [SpaceXPluginFeature()],
    initialPath: '/',
  ));
}
