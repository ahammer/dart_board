import 'package:dart_board_core/dart_board.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Dart Board Feedback Feature
///
/// Exposes a "/feedback" route
/// Also exposes a method
class DartBoardFeedbackFeature extends DartBoardFeature {
  @override
  String get namespace => "feedback";

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: "/feedback", builder: (ctx, settings) => FeedbackScreen())
      ];

  @override
  Map<String, MethodCallHandler> get methodHandlers => {
        "showFeedback": (ctx, call) =>
            showDialog(context: ctx, builder: (ctx) => RouteWidget("/feedback"))
      };
}

class FeedbackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Text("Feedback");
}
