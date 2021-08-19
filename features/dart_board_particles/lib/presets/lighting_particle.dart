import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../dart_board_particle_feature.dart';

/// This class provides a generic
class LightingParticle extends Particle {
  double r = Random().nextDouble();
  double r2 = Random().nextDouble();
  double r3 = Random().nextDouble();
  bool cw = Random().nextBool();
  double t = 0.0;
  double x = 0;
  double y = 0.0;
  double s = 0.0;

  @override
  void step(double time, Size size) {
    t = t + (time * 10);
    x = size.width / 2 +
        cos(0.5 * (cw ? -1 : 1) * t * r) *
            min((r * r2) * (t * t) + (r + r2 + r3) * size.width * 2,
                t * 10 * (r + r2 + r3));
    y = size.height / 2 +
        sin(0.5 * (cw ? -1 : 1) * t * r2) *
            min((r2 * r3) * (t * t) + (r + r2 + r3) * size.height * 2,
                t * 10 * (r + r2 + r3));
    s = min<double>(
            t * r3 * r2 * r * (t < 5 ? 1.0 : (pow(t / 5, 5))) / 5, 2000.0) +
        r +
        r2 +
        r3 +
        3;
  }
}

class LightingParticleLayer extends ParticleLayer<LightingParticle> {
  final _particleList = <LightingParticle>[
    LightingParticle(),
    LightingParticle(),
    LightingParticle(),
    LightingParticle(),
    LightingParticle(),
    LightingParticle(),
    LightingParticle(),
    LightingParticle(),
    LightingParticle(),
    LightingParticle(),
    LightingParticle(),
    LightingParticle(),
    LightingParticle(),
    LightingParticle(),
    LightingParticle(),
    LightingParticle(),
    LightingParticle(),
    LightingParticle(),
    LightingParticle(),
    LightingParticle(),
    LightingParticle(),
    LightingParticle(),
    LightingParticle(),
    LightingParticle(),
    LightingParticle(),
    LightingParticle(),
    LightingParticle(),
    LightingParticle(),
    LightingParticle(),
    LightingParticle(),
    LightingParticle(),
    LightingParticle(),
    LightingParticle()
  ];

  @override
  void before(Canvas canvas, Size size) {
    canvas.saveLayer(Rect.largest, Paint());
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()
          ..shader = LinearGradient(colors: [
            Colors.black,
            Colors.black.withOpacity(max(1.0 - time / 5, 0)),
            Colors.black
          ], transform: GradientRotation(time / 10))
              .createShader(Rect.fromLTWH(0, 0, size.width, size.height)));
  }

  @override
  void after(Canvas canvas, Size size) {
    canvas.restore();
  }

  @override
  void drawParticle(Canvas canvas, Size size, LightingParticle particle) {
    canvas.save();
    canvas.translate(particle.x, particle.y);
    canvas.scale(particle.s, particle.s);
    canvas.drawCircle(
        Offset.zero,
        0.5,
        Paint()
          ..blendMode = BlendMode.clear
          ..maskFilter =
              MaskFilter.blur(BlurStyle.normal, (particle.t / 100.0) / 1));
    canvas.restore();
  }

  @override
  List<LightingParticle> get particles => _particleList;

  /// This effect last 3s and then disapears
  @override
  bool get isDead => time > 3;
}
