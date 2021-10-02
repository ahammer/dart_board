import 'package:dart_board_core_plugin/add_2_app_feature.dart';
import 'package:flutter/material.dart';

import 'package:dart_board_core/dart_board.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(DartBoard(
    features: [TestFeature(), DartBoardAdd2AppFeature()],
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
                  appBar: AppBar(
                    leading: BackButton(
                      onPressed: () => SystemNavigator.pop(),
                    ),
                  ),
                  body: const Text('hello'),
                )),
        NamedRouteDefinition(
            route: '/home2',
            builder: (ctx, settings) => Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    leading: BackButton(
                      onPressed: () => SystemNavigator.pop(),
                    ),
                  ),
                  body: const Text('hello2'),
                )),
        NamedRouteDefinition(
            route: '/home3',
            builder: (ctx, settings) => Scaffold(
                  appBar: AppBar(
                    leading: BackButton(
                      onPressed: () => SystemNavigator.pop(),
                    ),
                  ),
                  body: const Text('hello3'),
                ))
      ];
}
