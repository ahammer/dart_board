import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_core/impl/dart_board_core.dart';
import 'package:dart_board_locator/dart_board_locator.dart';
import 'package:flutter/material.dart';

import 'dart_board_authentication.dart';

void main() => runApp(DartBoard(
    features: [DartBoardAuthenticationExample()], initialRoute: '/main'));

/// Example Feature to demonstrate Authentication
class DartBoardAuthenticationExample extends DartBoardFeature {
  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: "/main", builder: (ctx, settings) => MainWidget())
      ];

  @override
  List<DartBoardFeature> get dependencies =>
      [DartBoardAuthenticationFeature(), DartBoardFakeAuthProvider()];
}

/// This is a mock auth provider that can just flip the state to signed in
///
class DartBoardFakeAuthProvider extends DartBoardFeature {
  @override
  List<DartBoardDecoration> get appDecorations => [
        DartBoardAuthenticationProviderAppDecoration(
            "mock", MockAuthenticationDelegate())
      ];

  @override
  List<DartBoardFeature> get dependencies => [DartBoardLocatorFeature()];
}

class MockAuthenticationDelegate extends AuthenticationDelegate {
  @override
  String get name => "Mock Authenticator";

  @override
  Widget buildAuthWidget() => MaterialButton(
      onPressed: () {
        /// This is called to set that we are now signed in with this delegate
        locate<AuthenticationState>().setSignedIn(true, this);

        /// Pop the auth dialog
        navigator.pop();
      },
      child: Text("Click to sign in"));
}

class MainWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
            child: Card(
                child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: LoginButton(),
        ))),
      );
}
