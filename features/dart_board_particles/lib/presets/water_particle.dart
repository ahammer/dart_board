import 'dart:math';

import 'package:dart_board_core/dart_board.dart';

import '../dart_board_particle_feature.dart';

/// This class provides a generic
class WaterParticle extends Particle {
  HSLColor c = HSLColor.fromAHSL(
      1.0, (DateTime.now().millisecondsSinceEpoch) % 32 + 100, 1.0, 0.3);

  double r = Random().nextDouble() / 2;
  double r2 = (Random().nextDouble() - 0.5);
  double t = 0.0;
  double x = -1;
  double y = -1;
  double s = 10.0;

  @override
  void step(double time, Size size) {
    y += time;
    x += time * (r2);
    t += time;
  }
}

class WaterParticleLayer extends ParticleLayer<WaterParticle> {
  final _particleList = <WaterParticle>[
    WaterParticle(),
    WaterParticle(),
    WaterParticle(),
    WaterParticle(),
    WaterParticle(),
    WaterParticle(),
    WaterParticle(),
    WaterParticle(),
    WaterParticle(),
    WaterParticle(),
    WaterParticle(),
    WaterParticle(),
    WaterParticle(),
    WaterParticle(),
    WaterParticle(),
    WaterParticle(),
    WaterParticle(),
    WaterParticle(),
    WaterParticle(),
  ];

  WaterParticleLayer();

  @override
  void before(Canvas canvas, Size size) {}

  @override
  void after(Canvas canvas, Size size) {}

  @override
  void drawParticle(Canvas canvas, Size size, WaterParticle particle) {
    canvas.save();
    canvas.translate(particle.x, particle.y);
    final s = particle.s * pow((particle.t + 1), 2);
    canvas.scale(s, s);
    canvas.drawCircle(
        Offset.zero,
        0.5,
        Paint()
          ..color = particle.c.toColor().withOpacity((1 - particle.t) / 2)
          ..blendMode = BlendMode.overlay
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, (particle.t) / 4));
    canvas.restore();
  }

  @override
  List<WaterParticle> get particles => _particleList;

  /// This effect last 3s and then disapears
  @override
  bool get isDead => time > 1;
}
