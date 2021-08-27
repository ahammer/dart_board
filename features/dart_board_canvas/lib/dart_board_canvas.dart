import 'package:dart_board_core/dart_board.dart';
import 'package:flutter/material.dart';

class DartBoardCanvasFeature extends DartBoardFeature {
  /// Namespace this feature will take (it's flexible)
  final String namespace;

  /// Implementation Name of this feature
  final String implementationName;

  /// Route that will be exposed by this feature
  final String route;

  /// This will paint on the screen
  final Function(Canvas canvas, Size size) paintFunction;

  late final painter = CanvasFeaturePainter(paintFunction);
  late final widget = Container(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(painter: painter));

  DartBoardCanvasFeature({
    required this.namespace,
    required this.implementationName,
    required this.route,
    required this.paintFunction,
  });

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: route, builder: (context, settings) => widget)
      ];
}

class CanvasFeaturePainter extends CustomPainter {
  final Function(Canvas canvas, Size size) paintFunction;

  CanvasFeaturePainter(this.paintFunction);

  @override
  void paint(Canvas canvas, Size size) => paintFunction(canvas, size);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
