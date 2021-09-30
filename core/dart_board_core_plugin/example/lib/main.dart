import 'package:flutter/material.dart';

import 'package:dart_board_core/dart_board.dart';

void main() {
  runApp(DartBoard(
    features: [TestFeature()],
    initialRoute: '/home',
  ));
}

class TestFeature extends DartBoardFeature {
  @override
  String get namespace => 'test';

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: '/home',
            builder: (ctx, settings) => Scaffold(
                  appBar: AppBar(),
                  body: const Text('hello'),
                )),
        NamedRouteDefinition(
            route: '/home',
            builder: (ctx, settings) => Scaffold(
                  appBar: AppBar(),
                  body: const Text('hello2'),
                ))
      ];
}
