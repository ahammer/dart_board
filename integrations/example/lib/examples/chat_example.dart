import 'package:dart_board_core/impl/dart_board_core.dart';
import 'package:example/example_feature.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(DartBoard(
    featureOverrides: {
      'Snow': null,
      'FireCursor': null,
      'RainbowCursor': null,
      'SplashScreen': null,
    },
    features: [ExampleFeature()],
    initialRoute: '/chat',
  ));
}
