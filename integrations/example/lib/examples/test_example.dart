import 'package:dart_board_core/dart_board.dart';
import 'package:flutter/material.dart';

main(List<String> args) {
  runApp(DartBoard(
    featureOverrides: {'FeatureA': null},
    features: [FeatureB(blocking: false)],
    initialRoute: '/main',
  ));
}

class FeatureA extends DartBoardFeature {
  @override
  String get namespace => 'FeatureA';
}

class FeatureB extends DartBoardFeature {
  final bool blocking;

  FeatureB({required this.blocking});

  @override
  String get namespace => 'FeatureB';

  @override
  List<DartBoardDecoration> get pageDecorations => [
        FeatureGatePageDecoration('FeatureA', autoEnable: !blocking),
      ];

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: '/main',
            builder: (ctx, settings) => Card(
                  child: Text('test passed'),
                ))
      ];

  @override
  List<DartBoardFeature> get dependencies => [FeatureA()];
}
