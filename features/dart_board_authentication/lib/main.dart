import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_core/impl/dart_board_core.dart';
import 'package:flutter/material.dart';

void main() => runApp(DartBoard(features: [], initialRoute: '/main'));

class DartBoardAuthenticationExample extends DartBoardFeature {
  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: "/main", builder: (ctx, settings) => MainWidget())
      ];
}

class MainWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Text("Hello"),
      );
}
