import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class AnimatedBackgroundDecoration extends StatefulWidget {
  final Widget child;
  final Color color;

  const AnimatedBackgroundDecoration(
      {Key? key, required this.child, required this.color})
      : super(key: key);

  @override
  _AnimatedBackgroundDecorationState createState() =>
      _AnimatedBackgroundDecorationState();
}

class _AnimatedBackgroundDecorationState
    extends State<AnimatedBackgroundDecoration>
    with SingleTickerProviderStateMixin {
  late AnimationController animation;
  late double random;
  @override
  void initState() {
    super.initState();
    random = Random().nextDouble() * 100;
    animation = AnimationController(vsync: this);
    animation.repeat(
        min: 0.0, max: 1.0, period: Duration(minutes: 100), reverse: true);
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          AnimatedBuilder(
              animation: animation,
              builder: (ctx, child) => Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: CustomPaint(
                      painter: BackgroundPainter(
                          animation.value + random, widget.color)))),
          widget.child,
        ],
      );
}

class BackgroundPainter extends CustomPainter {
  final double value;
  final Color backgroundColor;

  BackgroundPainter(this.value, this.backgroundColor);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = backgroundColor);
    drawForValue(
        canvas, size, value, Colors.cyan, size.height / 25, size.height / 10);
    drawForValue(canvas, size, value * 1.5 + 2231.2, Colors.pink,
        size.height / 20, size.height / 10);
    drawForValue(canvas, size, value * 2 + 512.2, Colors.yellow,
        size.height / 15, size.height / 10);
  }

  void drawForValue(Canvas canvas, Size size, double value, Color color,
      double height, double width) {
    return canvas.drawPoints(
        PointMode.lines,
        [
          for (int i = 0; i < 20; i++)
            Offset(
                size.width / 19.0 * i,
                size.height / 2 +
                    (cos(value * 100 + value + i / 50.0) +
                            cos(value * 50 + value + i / 15.0) +
                            cos(value * 300 + value + i / 8.0) +
                            (cos(value * -300 + value + i / 2.0) +
                                    cos(value * -305 + value + i / 3.0) +
                                    cos(value * 315 + value + i / 4.0)) /
                                3.0 +
                            cos(value * 205 + value + i / 15.0)) *
                        height *
                        3)
        ].convertToSolidLine(),
        Paint()
          ..blendMode = BlendMode.darken
          ..color = color
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke
          ..strokeWidth = width);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

extension SolidLinefeature on List<Offset> {
  List<Offset> convertToSolidLine() {
    final result = <Offset>[];
    result.add(first);
    for (var i = 1; i < length - 1; i++) {
      result.add(this[i]);
      result.add(this[i]);
    }
    result.add(last);
    return result;
  }
}
