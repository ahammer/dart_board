import 'package:dart_board_core/dart_board.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(DartBoard(features: [Nav2Feature()], initialRoute: '/home'));
}

class Nav2Feature extends DartBoardFeature {
  @override
  String get namespace => 'nav2';

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: '/home',
            builder: (ctx, settings) => Material(
                child: Center(
                    child: MaterialButton(
                        onPressed: () {
                          DartBoardCore.instance
                              .pushRoute('/root/cata/details');
                        },
                        child: Text('Go To Details'))))),
        PathedRouteDefinition()
      ];
}
