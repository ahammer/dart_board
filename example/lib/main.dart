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
/// you'd like to support.
/// 
/// You then point an entry point.
/// 
/// Dart board handles loading your features, named route navigation, 
/// and app and page decorations.
/// 
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

