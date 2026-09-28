import 'dart:js_interop';
import 'package:firebase_core/firebase_core.dart';

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

FirebaseOptions? getFirebaseOptions() {
  final config = firebaseConfig;
  if (config == null) return null;

  return FirebaseOptions(
    apiKey: config.apiKey,
    appId: config.appId,
    messagingSenderId: config.messagingSenderId,
    projectId: config.projectId,
    authDomain: config.authDomain,
    storageBucket: config.storageBucket,
    measurementId: config.measurementId,
  );
}
