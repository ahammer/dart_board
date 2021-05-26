import 'package:dart_board/dart_board.dart';
import 'package:flutter/material.dart';
import 'example_feature.dart';

/// The App Entry Point
///
/// Use the DartBoard widget as your Route Widget
void main() => runApp(DartBoard(
      /// Bring in the features you use
      features: [ExampleFeature()],

      /// And set your entry point
      initialRoute: '/main',
    ));
