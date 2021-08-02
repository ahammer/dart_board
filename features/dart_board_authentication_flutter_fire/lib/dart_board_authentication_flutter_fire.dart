import 'package:dart_board_authentication/dart_board_authentication.dart';
import 'package:dart_board_core/dart_board.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class DartBoardAuthenticationFlutterFireFeature extends DartBoardFeature {
  late final delegate = FlutterFireAuthenticationDelegate();

  @override
  List<DartBoardFeature> get dependencies => [DartBoardAuthenticationFeature()];

  @override
  List<DartBoardDecoration> get appDecorations =>
      [DartBoardAuthenticationProviderAppDecoration("Flutter-Fire", delegate)];
}

class FlutterFireAuthenticationDelegate extends AuthenticationDelegate {
  @override
  Widget buildAuthWidget() => MaterialButton(
      onPressed: () {
        FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
      },
      child: Text("Sign in with Firebase"));
  @override
  String get name => "Flutter Fire - Auth Adapter";
}
