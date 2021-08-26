import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_log/dart_board_log.dart';
import 'package:flutter/material.dart';

/// Minimal Dart Board example + Logging
void main() => runApp(DartBoard(
      initialRoute: '/home',
      features: [LogFeature(), ScaffoldFeature(), SimpleRouteFeature()],
    ));

class ScaffoldFeature extends DartBoardFeature {
  @override
  String get namespace => 'scaffold';

  @override
  List<DartBoardDecoration> get pageDecorations => [
        DartBoardDecoration(
            name: 'scaffold_widget',
            decoration: (ctx, child) => Scaffold(
                  appBar: AppBar(title: Text('example')),
                  body: Container(
                      color: Colors.blue,
                      width: double.infinity,
                      height: double.infinity,
                      child: FittedBox(fit: BoxFit.contain, child: child)),
                ))
      ];
}

class SimpleRouteFeature extends DartBoardFeature {
  @override
  String get namespace => 'main_page';

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: '/home',
            builder: (ctx, settings) => Card(
                    child: Column(
                  children: [
                    Text('Home Page'),
                    MaterialButton(
                      onPressed: () => Navigator.of(ctx).pushNamed('/second'),
                      child: Text('push another route'),
                    ),
                  ],
                ))),
        NamedRouteDefinition(
            route: '/second',
            builder: (ctx, settings) => Card(
                    child: Column(
                  children: [
                    Text('Second Page'),
                    MaterialButton(
                      onPressed: Navigator.of(ctx).pop,
                      child: Text('pop'),
                    ),
                  ],
                ))),
      ];
}
