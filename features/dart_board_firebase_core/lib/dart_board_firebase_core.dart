import 'dart:io';
import 'dart:js' as js;

import 'package:dart_board_core/dart_board_core.dart';
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
  String get namespace => "FirebaseCore";

  @override
  bool get enabled =>
      kIsWeb || Platform.isAndroid || Platform.isIOS || Platform.isMacOS;
}

// Blocks the app from starting before firebase init'd
class FirebaseGateway extends StatefulWidget {
  final Widget child;

  FirebaseGateway({required this.child})
      : super(key: ValueKey("FirebaseGateway"));

  @override
  _FirebaseGatewayState createState() => _FirebaseGatewayState();
}

class _FirebaseGatewayState extends State<FirebaseGateway> {
  late final initFuture;

  @override
  void initState() {
    initFuture = _initializeFirebase();
    super.initState();
  }

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseOptions? options;
    
    if (kIsWeb) {
      // Check if firebaseConfig is available in the window object
      if (js.context.hasProperty('firebaseConfig')) {
        final config = js.JsObject.fromBrowserObject(js.context['firebaseConfig']);
        options = FirebaseOptions(
          apiKey: config['apiKey'],
          appId: config['appId'],
          messagingSenderId: config['messagingSenderId'],
          projectId: config['projectId'],
          authDomain: config['authDomain'],
          storageBucket: config['storageBucket'],
          measurementId: config['measurementId'],
        );
      }
    }
    
    return await Firebase.initializeApp(options: options);
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: initFuture,
      builder: (ctx, snapshot) {
        if (snapshot.hasError) {
          return Container(child: Text('${snapshot.error}'));
        }
        return snapshot.connectionState == ConnectionState.done
            ? widget.child
            : Container();
      });
}
