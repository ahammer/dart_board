import 'dart:io';
import 'package:dart_board_core/dart_board_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:js_interop';

@JS('firebaseConfig')
external JSObject? get firebaseConfig;

extension FirebaseConfigExtension on JSObject {
  external String get apiKey;
  external String get appId;
  external String get messagingSenderId;
  external String get projectId;
  external String? get authDomain;
  external String? get storageBucket;
  external String? get measurementId;
}

class DartBoardFirebaseCoreFeature extends DartBoardFeature {
  @override
  List<DartBoardDecoration> get appDecorations => [
        DartBoardDecoration(
          name: "FirebaseApp",
          decoration: (ctx, child) => FirebaseGateway(child: child),
        )
      ];

  @override
  String get namespace => "FirebaseCore";

  @override
  bool get enabled =>
      kIsWeb || Platform.isAndroid || Platform.isIOS || Platform.isMacOS;
}

class FirebaseGateway extends StatefulWidget {
  final Widget child;

  FirebaseGateway({required this.child})
      : super(key: const ValueKey("FirebaseGateway"));

  @override
  _FirebaseGatewayState createState() => _FirebaseGatewayState();
}

class _FirebaseGatewayState extends State<FirebaseGateway> {
  late final Future<FirebaseApp> initFuture;

  @override
  void initState() {
    initFuture = _initializeFirebase();
    super.initState();
  }

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseOptions? options;

    if (kIsWeb && firebaseConfig != null) {
      final config = firebaseConfig!;
      options = FirebaseOptions(
        apiKey: config.apiKey,
        appId: config.appId,
        messagingSenderId: config.messagingSenderId,
        projectId: config.projectId,
        authDomain: config.authDomain,
        storageBucket: config.storageBucket,
        measurementId: config.measurementId,
      );
    }

    return await Firebase.initializeApp(options: options);
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<FirebaseApp>(
        future: initFuture,
        builder: (ctx, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return snapshot.connectionState == ConnectionState.done
              ? widget.child
              : const Center(child: CircularProgressIndicator());
        },
      );
}