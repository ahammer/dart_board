import 'dart:io';

import 'package:dart_board_authentication/dart_board_authentication.dart';
import 'package:dart_board_core/dart_board_core.dart';
import 'package:dart_board_firebase_core/dart_board_firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dart_board_widgets/dart_board_widgets.dart';
import 'package:dart_board_locator/dart_board_locator.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// This is the firebase Delegate
late final _firebaseDelegate = FlutterFireAuthenticationDelegate();

/// Firebase Authentication Feature
///
/// 1) Setup firebase (web/android/iOS/macOS)
/// 2) web: Ensure your domains are registered in developer console as auth redirect domains

class DartBoardAuthenticationFlutterFireFeature extends DartBoardFeature {
  @override
  List<DartBoardFeature> get dependencies =>
      [DartBoardAuthenticationFeature(), DartBoardFirebaseCoreFeature()];

  @override
  List<DartBoardDecoration> get appDecorations => [
        DartBoardAuthenticationProviderAppDecoration(
            "Flutter-Fire", _firebaseDelegate),
        DartBoardDecoration(
            name: "FirebaseListener",
            decoration: (ctx, child) => LifeCycleWidget(
                init: (ctx) {
                  FirebaseAuth.instance.userChanges().listen((User? user) {
                    if (user != null) {
                      locate<AuthenticationState>()
                          .setSignedIn(true, _firebaseDelegate);
                    } else {
                      locate<AuthenticationState>().setSignedIn(false, null);
                    }
                  });
                },
                key: ValueKey("FirebaseListener"),
                child: child))
      ];

  @override
  String get namespace => "FirebaseAuth";

  /// Firebase Auth is only supported by these platforms
  @override
  bool get enabled =>
      kIsWeb || Platform.isAndroid || Platform.isIOS || Platform.isMacOS;
}

/// This is the authentication delegate for firebase
class FlutterFireAuthenticationDelegate extends AuthenticationDelegate {
  @override
  Widget buildAuthWidget() => LifeCycleWidget(
        key: ValueKey("GoogleAuthLifeCycle"),
        child: Container(),
        init: (ctx) async {
          navigator.pop();

          if (kIsWeb) {
            /// Web authentication via popup
            await FirebaseAuth.instance.signInWithPopup(GoogleAuthProvider());
            locate<AuthenticationState>().setSignedIn(true, this);
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

  @override
  Widget get loginButtonWidget => Text("Google Sign In");
}
