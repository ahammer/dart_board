import 'package:dart_board/dart_board.dart';
import 'package:example/impl/routes/custom_routes.dart';
import 'package:flutter/material.dart';

import 'example_feature.dart';

/// This is the entry point. We don't want to pollute
/// the main with much.
///
/// Treat this as a configuration file
///
/// A bit about what is going on here
///
/// 1) We are starting with a DartBoard Widget
/// 2) We are adding our integration feature
/// 3) We are setting an initial route (/home)
/// 4) We are setting a default "fade" transition for navigation
///
/// To further understand how this all works, the next place to look
/// is ExampleFeature()
///
/// It will bring in the other features
/// and provide the screens/decorations
/// for this example
///
void main() => runApp(DartBoard(
      features: [ExampleFeature()],
      initialRoute: '/main',
      routeBuilder: kFadeRouteBuilder,
    ));
