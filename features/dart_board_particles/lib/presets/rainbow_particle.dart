import 'package:flutter/painting.dart';
import '../dart_board_particle_feature.dart';

/// This class provides a generic
class RainbowParticle extends Particle {
  Color c = HSLColor.fromAHSL(
          1.0, (DateTime.now().millisecondsSinceEpoch) % 360, 1.0, 0.75)
      .toColor();
  double t = 0.0;
  double s = 10.0;

  @override
  void step(double time, Size size) => t += time;
}

class RainbowParticleLayer extends ParticleLayer<RainbowParticle> {
  final double screenX, screenY;
  final double lastScreenX, lastScreenY;

  final _particleList = <RainbowParticle>[
    RainbowParticle(),
  ];

  RainbowParticleLayer(
      this.screenX, this.screenY, this.lastScreenX, this.lastScreenY);

  @override
  void before(Canvas canvas, Size size) {}

  @override
  void after(Canvas canvas, Size size) {}

  @override
  void drawParticle(Canvas canvas, Size size, RainbowParticle particle) =>
      canvas.drawLine(
          Offset(screenX, screenY),
          Offset(lastScreenX, lastScreenY),
          Paint()
            ..color = particle.c.withOpacity(1 - particle.t / 0.5)
            ..strokeWidth = 10.0 * 1 / (1 + particle.t * 5));

  @override
  List<RainbowParticle> get particles => _particleList;

  /// This effect last 3s and then disapears
  @override
  bool get isDead => time > 0.5;
}
