import 'dart:math';
import 'dart:ui';

import 'package:dart_board_core/dart_board_core.dart';
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
              builder: (ctx, settings) => IgnorePointer(
                  child: AnimatedCanvasWidget(state: FpsPainter())))
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
    state.x = _DrawContext(size.width, size.height);
    state.c = canvas;

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

  /// Funvas inspired interfaces
  double get t => time;
  double C(double v) => cos(v);
  double S(double v) => sin(v);
  double T(double v) => tan(v);
  Color R(num r, num g, num b, [num? o]) =>
      Color.fromRGBO(r ~/ 1, g ~/ 1, b ~/ 1, (o ?? 1).toDouble());
  late Canvas c;
  late _DrawContext x;

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

  /// NOTE: Yanked from Funvas
  /// Scales the canvas to a square with side lengths of [dimension].
  ///
  /// Additionally, translate the canvas, so that the square is centered (in
  /// case the original size does not have an aspect ratio of `1`.
  /// This means that dimensions will not be distorted (pixel aspect ratio will
  /// stay the same) and instead, there will be unused space in case the
  /// original dimensions had a different aspect ratio than `1`.
  /// Furthermore, to ensure the square effect, the square will be clipped.
  ///
  /// The translation and clipping can also be turned off by passing [translate]
  /// and [clip] as false.
  ///
  /// Returns the scaled width and height as a [Size]. If [translate] is `true`,
  /// the returned size will be a square of the given [dimension]. Otherwise,
  /// the returned size might have one side that is larger.
  ///
  /// ### Use cases
  ///
  /// This method is useful if you know that you will be designing a funvas for
  /// certain dimensions. This way, you can use fixed values for all sizes in
  /// the animation and when the funvas is displayed in different dimensions,
  /// your fixed dimensions still work.
  ///
  /// I use this a lot because I know what dimensions I want to have for the
  /// GIF that I will be posting to Twitter beforehand.
  ///
  /// ### Notes
  ///
  /// "s2q" stands for "scale to square". I decided to not use "s2s" because
  /// it sounded a bit weird.
  ///
  /// ---
  ///
  /// My usage recommendation is the following:
  ///
  /// ```dart
  /// final s = s2q(750), w = s.width, h = s.height;
  /// ```
  ///
  /// You could of course simply use a single variable for the dimensions since
  /// `w` and `h` will be equal for a square. However, using my way will allow
  /// you to stay flexible. You could simply disable [translate] later on and/or
  /// use a different aspect ratio :)
  Size s2q(
    double dimension, {
    bool translate = true,
    bool clip = true,
  }) {
    final shortestSide = min(x.width, x.height);
    if (translate) {
      // Center the square.
      c.translate((x.width - shortestSide) / 2, (x.height - shortestSide) / 2);
    }

    final scaling = shortestSide / dimension;
    c.scale(scaling);
    final scaledSize = translate
        ? Size.square(dimension)
        : Size(x.width / scaling, x.height / scaling);

    if (clip) {
      c.clipRect(Offset.zero & scaledSize);
    }

    return scaledSize;
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

class _DrawContext {
  final double width;
  final double height;

  _DrawContext(this.width, this.height);
}
