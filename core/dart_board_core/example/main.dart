import 'package:dart_board_core/dart_board_core.dart';
import 'package:dart_board_core/interface/nav_interface.dart';
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
      features: [ScaffoldFeature(), SimpleRouteFeature()],
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
        MapRouteDefinition(routeMap: {
          '/home': (ctx, settings) => Card(
                  child: Column(
                children: [
                  Text('Home Page'),
                  MaterialButton(
                    onPressed: () => DartBoardCore.nav.push("/second"),
                    child: Text('push another route'),
                  ),
                ],
              ))
        }),
        NamedRouteDefinition(
            route: '/second',
            builder: (ctx, settings) => Card(
                    child: Column(
                  children: [
                    Text('Second Page'),
                    MaterialButton(
                      onPressed: DartBoardCore.nav.pop,
                      child: Text('pop'),
                    ),
                  ],
                ))),
      ];
}
