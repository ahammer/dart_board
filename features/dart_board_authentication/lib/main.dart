import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_core/impl/dart_board_core.dart';
import 'package:dart_board_locator/dart_board_locator.dart';
import 'package:flutter/material.dart';

import 'dart_board_authentication.dart';

void main() => runApp(DartBoard(
    features: [DartBoardAuthenticationExample()], initialRoute: '/main'));

class DartBoardAuthenticationExample extends DartBoardFeature {
  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: "/main", builder: (ctx, settings) => MainWidget())
      ];

  @override
  List<DartBoardFeature> get dependencies => [DartBoardAuthenticationFeature()];
}

class MainWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
            child: Card(
                child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AuthenticationGate(
            signedIn: (ctx) => Text("Signed in"),
            signedOut: (ctx) => Text("Not logged in"),
          ),
        ))),
      );
}
