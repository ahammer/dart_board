import 'dart:math';

import 'package:flutter/material.dart';

import '../dart_board_particle_feature.dart';

/// This class provides a generic
class FireParticle extends Particle {
  final c = HSLColor.fromAHSL(
          0.8, (DateTime.now().millisecondsSinceEpoch) % 48, 1.0, 0.6)
      .toColor();
  bool m = Random().nextDouble() > 0.5;
  double r = Random().nextDouble() / 2;
  double r2 = (Random().nextDouble() - 0.5);
  double r3 = Random().nextDouble() + 0.5;
  double t = 0.0;
  double x = Random().nextDouble() * 4 - 2;
  double y = Random().nextDouble() * 4 - 2;
  double s = 10.0;

  @override
  void step(double time, Size size) {
    y -= time * (r * 100);
    x += time * (r2 * 100);
    t += time;
  }
}

class FireParticleLayer extends ParticleLayer<FireParticle> {
  final double screenX, screenY;
  final _particleList = <FireParticle>[
    FireParticle(),
  ];

  FireParticleLayer(this.screenX, this.screenY);

  @override
  void before(Canvas canvas, Size size) {}

  @override
  void after(Canvas canvas, Size size) {}

  @override
  void drawParticle(Canvas canvas, Size size, FireParticle particle) {
    canvas.save();
    canvas.translate(particle.x + screenX, particle.y + screenY);
    final s = particle.s * pow((particle.t + 1), 2);
    canvas.scale(s * particle.r3, s * particle.r3);
    double o = (1 - particle.t) / 5;

    canvas.drawCircle(
        Offset.zero,
        0.5,
        Paint()
          ..color = particle.c.withOpacity(o)
          ..blendMode = particle.m ? BlendMode.plus : BlendMode.colorBurn
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, (particle.t) / 4));
    canvas.restore();
  }

  @override
  List<FireParticle> get particles => _particleList;

  /// This effect last 3s and then disapears
  @override
  bool get isDead => time > 1;
}
