import 'package:dart_board_authentication/dart_board_authentication.dart';
import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_firebase_core/dart_board_firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dart_board_core/impl/widgets/life_cycle_widget.dart';
import 'package:dart_board_locator/dart_board_locator.dart';

late final delegate = FlutterFireAuthenticationDelegate();

class DartBoardAuthenticationFlutterFireFeature extends DartBoardFeature {
  @override
  List<DartBoardFeature> get dependencies =>
      [DartBoardAuthenticationFeature(), DartBoardFirebaseAppFeature()];

  @override
  List<DartBoardDecoration> get appDecorations =>
      [DartBoardAuthenticationProviderAppDecoration("Flutter-Fire", delegate)];
}

/// This is the authentication delegate for firebase
class FlutterFireAuthenticationDelegate extends AuthenticationDelegate {
  @override
  Widget buildAuthWidget() => LifeCycleWidget(
        key: ValueKey("GoogleAuthLifeCycle"),
        child: CircularProgressIndicator(),
        init: (ctx) async {
          await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
          locate<AuthenticationState>().setSignedIn(true, this);
          navigator.pop();
        },
      );
  @override
  String get name => "Flutter Fire - Auth Adapter";
}
