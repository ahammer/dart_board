import 'dart:ui';

import 'package:dart_board_core/dart_board.dart';
import 'package:flutter/material.dart';

class DartBoardCanvasFeature<T extends AnimatedCanvasState>
    extends DartBoardFeature {
  final bool showFpsOverlay;

  /// Namespace this feature will take (it's flexible)
  final String namespace;

  /// Implementation Name of this feature
  final String implementationName;

  /// Route that will be exposed by this feature
  final String route;

  final T Function() stateBuilder;

  DartBoardCanvasFeature(
      {required this.namespace,
      required this.implementationName,
      required this.route,
      required this.stateBuilder,
      this.showFpsOverlay = false});

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: route,
            builder: (context, settings) =>
                AnimatedCanvasWidget(state: stateBuilder())),
        if (showFpsOverlay)
          NamedRouteDefinition(
              route: "/fps",
              builder: (ctx, settings) =>
                  AnimatedCanvasWidget(state: FpsPainter()))
      ];

  @override
  List<DartBoardDecoration> get appDecorations => [
        if (showFpsOverlay)
          DartBoardDecoration(
              name: "FpsOverlay",
              decoration: (context, child) => Stack(
                    children: [
                      child,
                      Container(
                        width: 40,
                        height: 40,
                        child: RouteWidget("/fps"),
                      )
                    ],
                  ))
      ];
}

class AnimatedCanvasWidget extends StatefulWidget {
  const AnimatedCanvasWidget({
    Key? key,
    required this.state,
  }) : super(key: key);

  final AnimatedCanvasState state;

  @override
  _AnimatedCanvasWidgetState createState() => _AnimatedCanvasWidgetState();
}

class _AnimatedCanvasWidgetState extends State<AnimatedCanvasWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController =
      AnimationController.unbounded(
          vsync: this, duration: Duration(days: 1000000));
  @override
  void initState() {
    super.initState();
    widget.state.init(context);
    _animationController.forward();
  }

  @override
  void dispose() {
    widget.state.dispose();
    _animationController.stop();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
      width: double.infinity,
      height: double.infinity,
      child: AnimatedBuilder(
          animation: _animationController,
          builder: (ctx, child) =>
              CustomPaint(painter: CanvasFeaturePainter(widget.state))));
}

/// This is the CustomPainter that is actually setting up the draw
/// It'll track timing, call out the step() call and the paint() call.
class CanvasFeaturePainter extends CustomPainter {
  final AnimatedCanvasState state;

  CanvasFeaturePainter(this.state);

  @override
  void paint(Canvas canvas, Size size) {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final lastTime = state._lastFrameEpochMs ?? currentTime;
    final deltaTime = (currentTime - lastTime) / 1000.0;
    if (currentTime != lastTime) {
      int fps = (1000 ~/ (currentTime - lastTime));
      state._fps = (fps + state._fps * 3) ~/ 4;
    }
    state.step(deltaTime);
    return state.paint(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// This is a state object that tracks time.
/// Base class to track the state
abstract class AnimatedCanvasState {
  int? _lastFrameEpochMs;
  int _fps = 0;
  BuildContext? _context;
  BuildContext get context => _context!;

  /// This should be safe in step and paint
  double _time = 0;
  double _timeDelta = 1;

  int get fps => _fps;
  double get time => _time;
  double get timeDelta => _timeDelta;

  /// This will paint on the screen
  void paint(Canvas canvas, Size size);

  @mustCallSuper
  void init(BuildContext context) {
    _context = context;
    _lastFrameEpochMs = DateTime.now().millisecondsSinceEpoch;
  }

  void dispose() {
    _context = null;
  }

  @mustCallSuper
  void step(double deltaTime) {
    _time += deltaTime;
    _timeDelta = deltaTime;
    _lastFrameEpochMs = DateTime.now().millisecondsSinceEpoch;
  }
}

/// This painter just shows the current FPS on the screen
class FpsPainter extends AnimatedCanvasState {
  @override
  void paint(Canvas canvas, Size size) {
    TextSpan span = new TextSpan(
        style: new TextStyle(
            color: Colors.lightGreenAccent,
            fontSize: 24.0,
            fontFamily: 'Roboto'),
        text: "$fps");
    TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, new Offset(0, 0));
  }
}
