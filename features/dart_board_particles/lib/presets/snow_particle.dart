import 'dart:math';
import 'dart:ui';

import 'package:dart_board_core/dart_board.dart';

import '../dart_board_particle_feature.dart';

/// This class provides a generic
class SnowParticle extends Particle {
  HSLColor c = HSLColor.fromAHSL(
      1.0, (DateTime.now().millisecondsSinceEpoch) % 32 + 100, 1.0, 0.3);

  double r = Random().nextDouble() - 0.5;
  double r2 = (Random().nextDouble() - 0.5);
  double t = 0.0;
  double x = Random().nextDouble() * 2000;
  double oldX = -1;
  double oldY = -1;

  double y = -1500 * Random().nextDouble();
  double ys = 0.0;
  double s = 2.0 + Random().nextDouble() / 10;

  @override
  void step(double time, Size size) {
    time /= 3;
    if (y > size.height) {
      // Init out of range
      y = 0;
      ys = Random().nextDouble() * 50 + 10;
      t = 0;
    }
    if (x > size.width) x -= size.width;
    if (x < 0) x += size.width;

    oldX = x;
    oldY = y;
    x += (cos(r * t * 3) * sin(r2 * t * 10)) / 30 * t;
    ys += t / 100 * (1 + r);
    if (ys > 80 * (2 + r)) ys = 80 * (2 + r);

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
        _particleList.map((e) => Offset(e.x, e.y)).toList(),
        Paint()
          ..color = Colors.white
          ..strokeWidth = 1);
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
