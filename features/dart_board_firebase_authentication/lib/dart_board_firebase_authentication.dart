import 'dart:html';

import 'package:dart_board_authentication/dart_board_authentication.dart';
import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_firebase_core/dart_board_firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dart_board_core/impl/widgets/life_cycle_widget.dart';
import 'package:dart_board_locator/dart_board_locator.dart';
import 'package:google_sign_in/google_sign_in.dart';

late final delegate = FlutterFireAuthenticationDelegate();

class DartBoardAuthenticationFlutterFireFeature extends DartBoardFeature {
  @override
  List<DartBoardFeature> get dependencies =>
      [DartBoardAuthenticationFeature(), DartBoardFirebaseAppFeature()];

  @override
  List<DartBoardDecoration> get appDecorations =>
      [DartBoardAuthenticationProviderAppDecoration("Flutter-Fire", delegate)];

  @override
  String get namespace => "FirebaseAuth";
}

/// This is the authentication delegate for firebase
class FlutterFireAuthenticationDelegate extends AuthenticationDelegate {
  @override
  Widget buildAuthWidget() => LifeCycleWidget(
        key: ValueKey("GoogleAuthLifeCycle"),
        child: CircularProgressIndicator(),
        init: (ctx) async {
          if (kIsWeb) {
            /// Web authentication via popup
            await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
            locate<AuthenticationState>().setSignedIn(true, this);
            navigator.pop();
          } else {
            // Trigger the authentication flow for mobile and other
            final GoogleSignInAccount googleUser =
                (await GoogleSignIn().signIn())!;

            // Obtain the auth details from the request
            final GoogleSignInAuthentication googleAuth =
                await googleUser.authentication;

            // Create a new credential
            final credential = GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            );

            // Once signed in, return the UserCredential
            await FirebaseAuth.instance.signInWithCredential(credential);
            // await FirebaseAuth.instance.si(GoogleAuthProvider());
            locate<AuthenticationState>().setSignedIn(true, this);
            navigator.pop();
          }
        },
      );
  @override
  String get name => "Flutter Fire - Auth Adapter";

  @override
  String get username =>
      FirebaseAuth.instance.currentUser?.displayName ?? "unknown";

  @override
  get photoUrl => FirebaseAuth.instance.currentUser?.photoURL ?? "";

  @override
  String get userId => FirebaseAuth.instance.currentUser?.uid ?? "";
}
