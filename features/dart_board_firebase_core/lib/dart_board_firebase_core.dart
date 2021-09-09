import 'dart:io';

import 'package:dart_board_core/dart_board.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Initialization Hook for Firebase App
/// For firebase-capable features to use
class DartBoardFirebaseCoreFeature extends DartBoardFeature {
  @override
  List<DartBoardDecoration> get appDecorations => [
        DartBoardDecoration(
            name: "FirebaseApp",
            decoration: (ctx, child) => FirebaseGateway(child: child))
      ];

  @override
  String get namespace => "DartBoardFirebaseCore";

  @override
  bool get enabled =>
      kIsWeb || Platform.isAndroid || Platform.isIOS || Platform.isMacOS;
}

class FirebaseGateway extends StatefulWidget {
  final Widget child;

  FirebaseGateway({required this.child})
      : super(key: ValueKey("FirebaseGateway"));

  @override
  _FirebaseGatewayState createState() => _FirebaseGatewayState();
}

class _FirebaseGatewayState extends State<FirebaseGateway> {
  final initFuture = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: initFuture,
      builder: (ctx, snapshot) =>
          snapshot.connectionState == ConnectionState.done
              ? widget.child
              : nil);
}
