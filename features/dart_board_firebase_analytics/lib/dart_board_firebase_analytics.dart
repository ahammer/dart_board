import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_firebase_core/dart_board_firebase_core.dart';
import 'package:dart_board_tracking/dart_board_tracking.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

/// Firebase analytics feature and a simple delegate
class DartBoardFirebaseAnalytics extends DartBoardFeature {
  @override
  List<DartBoardFeature> get dependencies =>
      [DartBoardFirebaseCoreFeature(), DartBoardTrackingFeature()];

  @override
  String get namespace => "DartBoardFirebaseAnalytics";

  @override
  List<DartBoardDecoration> get appDecorations => [
        TrackingDelegateAppDecoration(
            name: "firebase_analytics", delegate: FirebaseAnalyticsDelegate()),
      ];
}

class FirebaseAnalyticsDelegate extends TrackingDelegate {
  FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  void trackAction(
          BuildContext context, String name, Map<String, dynamic> extras) =>
      analytics.logEvent(name: "action_$name", parameters: extras);

  @override
  void trackPage(
          BuildContext context, String name, Map<String, dynamic> extras) =>
      analytics.logEvent(name: "page_$name", parameters: extras);
}
