import 'package:dart_board_core/dart_board.dart';
import 'package:flutter/material.dart';
import 'example_feature.dart';

/// Entry Point for the Example
///
/// All the registration and details are in ExampleFeature.
void main() {
  runApp(DartBoard(
    features: [ExampleFeature()],
    initialRoute: '/chat',
  ));
}
