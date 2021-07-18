import 'package:dart_board_core/dart_board.dart';
import '../dart_board_particle_feature.dart';

/// This class provides a generic
class RainbowParticle extends Particle {
  Color c = HSLColor.fromAHSL(
          1.0, (DateTime.now().millisecondsSinceEpoch) % 360, 1.0, 0.75)
      .toColor();
  double t = 0.0;
  double x = 0.0;
  double y = 0.0;
  double s = 10.0;

  @override
  void step(double time, Size size) => t += time;
}

class RainbowParticleLayer extends ParticleLayer<RainbowParticle> {
  final double screenX, screenY;
  final _particleList = <RainbowParticle>[
    RainbowParticle(),
  ];

  RainbowParticleLayer(this.screenX, this.screenY);

  @override
  void before(Canvas canvas, Size size) {}

  @override
  void after(Canvas canvas, Size size) {}

  @override
  void drawParticle(Canvas canvas, Size size, RainbowParticle particle) {
    canvas.save();
    canvas.translate(particle.x + screenX, particle.y + screenY);
    canvas.scale(particle.s, particle.s);
    canvas.drawCircle(Offset.zero, 0.5,
        Paint()..color = particle.c.withOpacity(1 - particle.t / 0.5)
        //..maskFilter =
        //MaskFilter.blur(BlurStyle.normal, (particle.t * 5) / 1));
        );
    canvas.restore();
  }

  @override
  List<RainbowParticle> get particles => _particleList;

  /// This effect last 3s and then disapears
  @override
  bool get isDead => time > 0.5;
}
