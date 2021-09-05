import 'package:flutter/material.dart';

/// Builds an AnimatedPainter object
typedef PainterBuilder = AnimatedPainter Function();

///
/// AnimatedPainter
///
/// Implement this interface to get an animated Canvas.
/// Use with AnimatedPaint() widget
///
/// Used by SpaceClock to paint the scene
/// paint() will be called as fast as possible
abstract class AnimatedPainter {
  /// Initialize the Painter (e.g. Load Images)
  void init();

  /// Paint to the canvas
  void paint(Canvas canvas, Size size);
}

///
/// AnimatedPaint
///
/// Provide a Painter() and this class will paint it
class AnimatedPaint extends StatefulWidget {
  /// Construct an AnimatedPaint to draw a AnimatedPainter
  const AnimatedPaint({required this.painter, Key? key}) : super(key: key);

  /// The Painter interface we are using
  final AnimatedPainter painter;

  @override
  _AnimatedPainterState createState() => _AnimatedPainterState();
}

class _AnimatedPainterState extends State<AnimatedPaint>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  // Every time the painter changes, track that change and init the new painter
  @override
  void didChangeDependencies() {
    widget.painter.init();
    super.didChangeDependencies();
  }

  // Start a
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this)
          ..repeat();
  }

  @override
  void dispose() {
    controller
      ..stop()
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
      width: double.infinity,
      height: double.infinity,
      child: CustomPaint(
          painter: _CustomPaintProxy(widget.painter, repaint: controller)));
}

///
/// _CustomPaintProxy
///
/// Adapts a CustomPaint to the AnimatedPaint interface
class _CustomPaintProxy extends CustomPainter {
  _CustomPaintProxy(this.painter, {Listenable? repaint})
      : super(repaint: repaint);

  final AnimatedPainter painter;

  @override
  void paint(Canvas canvas, Size size) => painter.paint(canvas, size);

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
