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

/// ----------------------------------------------
/// 
/// What is happening here?
/// 
/// When you start the App, you specify the features
/// you'd like to support. In this case I'm bringing the 
/// Example Feature in.
/// 
/// The example feature includes more Features, and offers
/// integration examples.
/// 
/// DartBoard will collect all these Features and collect
/// their capabilities (Routes/Decorations).
/// 
/// It will then inflate your initial route as your home page 
/// and initialize the framework to help decorate your pages
/// and install any app-level state/decorations from the features.
/// 

