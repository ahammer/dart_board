import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../dart_board_particle_feature.dart';

/// This class provides a generic
class SnowParticle extends Particle {
  HSLColor c = HSLColor.fromAHSL(
      1.0, (DateTime.now().millisecondsSinceEpoch) % 32 + 100, 1.0, 0.3);

  double r = Random().nextDouble() - 0.5;
  double r2 = (Random().nextDouble() - 0.5);
  double t = 0.0;
  double x = Random().nextDouble();
  double oldX = -1;
  double oldY = -1;

  double y = Random().nextDouble();
  double ys = Random().nextDouble() / 10;
  double s = 2.0 + Random().nextDouble() / 10;

  @override
  void step(double time, Size size) {
    time /= 3;
    if (y > 1) {
      // Init out of range
      y = 0;

      t = 0;
    }
    if (x > 1) x -= 1;
    if (x < 0) x += 1;

    oldX = x;
    oldY = y;

    x += (cos(r * t * 3) * sin(r2 * t * 10)) / 3000;

    y += time * ys;
    t += time;
  }
}

class SnowParticleLayer extends ParticleLayer<SnowParticle> {
  final _particleList = List.generate(300, (index) => SnowParticle());
  @override
  bool get needsAfter => false;

  @override
  bool get needsParticlePaint => false;

  @override
  void before(Canvas canvas, Size size) {
    canvas.drawPoints(
        PointMode.points,
        _particleList
            .take(_particleList.length ~/ 2)
            .map((e) => Offset(e.x * size.width, e.y * size.height))
            .toList(),
        Paint()
          ..color = Colors.white54
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..strokeWidth = 3);

    canvas.drawPoints(
        PointMode.points,
        _particleList
            .skip(_particleList.length ~/ 2)
            .map((e) => Offset(e.x * size.width, e.y * size.height))
            .toList(),
        Paint()
          ..color = Colors.grey
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..strokeWidth = 2);
  }

  @override
  void after(Canvas canvas, Size size) {}

  @override
  void drawParticle(Canvas canvas, Size size, SnowParticle particle) {}

  @override
  List<SnowParticle> get particles => _particleList;

  /// This effect last 3s and then disapears
  @override
  bool get isDead => false;
}
