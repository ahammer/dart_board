import 'package:dart_board/dart_board.dart';
import 'package:flutter/material.dart';
import 'example_feature.dart';

/// The Example Entry Point
///
/// Use the DartBoard widget as your Route Widget

void main() => runApp(DartBoard(
      features: [ExampleFeature()],
      initialRoute: '/main',
    ));

/// What is happening here?
/// -----------------------
/// 
/// When you start the App, you specify the features
/// you'd like to support. Even though we only specify one here
/// we are actually bringing in 6 Features, most come as Dependencies in the 
/// Extension itself.
/// 
/// The features we ultimately bring in to the example.
/// [Theme, Debug, Logging, MineSweeper, BottomNavTemplate, Example]
/// 
/// Dart board handles loading your features, named routes, 
/// and app and page decorations. 
/// 
/// It manages your MaterialApp for you, freeing you up to hook features
/// up easily and quickly.
/// 
/// What else would go in this file?
/// --------------------------------
/// 
/// Config should be pushed up to this file. 
/// It is the entry point and launch config.
/// 
/// 
/// Where do we go from here?
/// -------------------------
/// 
/// The meat of the platform is in the features.
/// The next page will outline what a feature can do
/// 
/// 
/// How can I see it?
/// -----------------
/// 
/// If you are in github, go to www.dart-board.io
/// If you are on the site, congrats, you are
/// running the example

