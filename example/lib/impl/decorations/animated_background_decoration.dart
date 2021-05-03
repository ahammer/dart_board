import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimatedBackgroundDecoration extends StatefulWidget {
  final Widget child;
  final Color color;

  const AnimatedBackgroundDecoration(
      {Key key, @required this.child, @required this.color})
      : super(key: key);

  @override
  _AnimatedBackgroundDecorationState createState() =>
      _AnimatedBackgroundDecorationState();
}

class _AnimatedBackgroundDecorationState
    extends State<AnimatedBackgroundDecoration>
    with SingleTickerProviderStateMixin {
  AnimationController animation;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(vsync: this);
    animation.repeat(
        min: 0.0, max: 1.0, period: Duration(seconds: 600), reverse: true);
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
                      painter:
                          BackgroundPainter(animation.value, widget.color)))),
          widget.child,
        ],
      );
}

class BackgroundPainter extends CustomPainter {
  final double value;
  final Color color;

  BackgroundPainter(this.value, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPoints(
        PointMode.lines,
        [
          for (int i = 0; i < 200; i++)
            Offset(
                size.width / 200.0 * i,
                size.height / 2 +
                    (cos(value * 100 + value + i / 50.0) +
                            cos(value * 50 + value + i / 25.0) +
                            cos(value * 300 + value + i / 50.0) +
                            (cos(value * -300 + value + i / 10.0) +
                                    cos(value * -305 + value + i / 5.0) +
                                    cos(value * 315 + value + i / 6.0)) /
                                3.0 +
                            cos(value * 205 + value + i / 80.0)) /
                        4 *
                        size.height /
                        2)
        ],
        Paint()
          ..blendMode = BlendMode.multiply
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeJoin = StrokeJoin.miter
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 100);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
