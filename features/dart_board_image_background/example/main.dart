import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_image_background/dart_board_image_background.dart';
import 'package:flutter/material.dart';

/// Minimal Dart Board example.
///
/// Provides a simple page, and a scaffold that would apply to all pages
/// and some basic navigation between 2 routes
///
/// For advanced usages, e.g. App Decorations, Multiple features, AB tests
/// check the example project in the root or at https://dart-board.io
void main() => runApp(DartBoard(
      initialPath: '/home',
      features: [
        SimpleRouteFeature(),
        ImageBackgroundFeature(
            filename: 'assets/image_bg_sample_asset.jpg',
            namespace: 'background',
            decorationName: 'background',
            implementationName: 'sample asset')
      ],
    ));

class SimpleRouteFeature extends DartBoardFeature {
  @override
  String get namespace => 'main_page';

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: '/home', builder: (ctx, settings) => Container()),
      ];
}
