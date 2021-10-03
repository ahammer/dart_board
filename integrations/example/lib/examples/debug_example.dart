import 'package:dart_board_core/dart_board.dart';
import 'package:flutter/material.dart';

import '../example_feature.dart';

/// Entry Point for the Example
///
/// Entry Point for the Example
///
/// All the registration and details are in ExampleFeature.
///
/// the FeatureOverrides are to disable certain features by default
void main() {
  runApp(DartBoard(
    featureOverrides: {
      'Snow': null,
      'FireCursor': null,
      'SplashScreen': null,
    },
    features: [ExampleFeature()],
    initialPath: '/debug',
  ));
}
