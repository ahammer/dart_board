import 'dart:io';

import 'package:dart_board_core/dart_board_core.dart';
import 'package:flutter/material.dart';
import 'example_feature.dart';

/// Entry Point for the Example
///
/// All the registration and details are in ExampleFeature.
///
/// the FeatureOverrides are to disable certain features by default
void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(DartBoard(
    featureOverrides: {
      'Snow': null,
      'FireCursor': null,
      'background': 'ClockEarth'
    },
    features: [ExampleFeature()],
    initialPath: '/main',
  ));
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
