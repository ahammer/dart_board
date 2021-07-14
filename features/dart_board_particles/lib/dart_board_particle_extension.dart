import 'dart:math';

import 'package:dart_board_core/interface/dart_board_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// This is an App decoration for particle effects
/// It'll overlay all your screens and give you access to a full screen canvas
class DartBoardParticleFeature extends DartBoardFeature with Particles {
  @override
  String get namespace => "Particles";

  @override
  List<DartBoardDecoration> get appDecorations => [
        DartBoardDecoration(
            name: "ParticleLayer",
            decoration: (context, child) => DartBoardParticleDecoration(
                  child: child,
                  interface: this,
                ))
      ];
}

class DartBoardParticleDecoration extends StatefulWidget {
  final Particles interface;
  final Widget child;
  const DartBoardParticleDecoration({
    required this.child,
    required this.interface,
    Key? key,
  }) : super(key: key);

  @override
  _DartBoardParticleDecorationState createState() =>
      _DartBoardParticleDecorationState();
}

class _DartBoardParticleDecorationState
    extends State<DartBoardParticleDecoration>
    with SingleTickerProviderStateMixin {
  late final ParticlePainter painter;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    painter = ParticlePainter(widget.interface);

    _controller = AnimationController.unbounded(
      duration: Duration(seconds: 1000),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          widget.child,
          IgnorePointer(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (ctx, _) => CustomPaint(
                  painter: ParticlePainter(widget.interface),
                ),
              ),
            ),
          )
        ],
      );
}

var lastFrame = DateTime.now().millisecondsSinceEpoch;

class ParticlePainter extends CustomPainter {
  final Particles interface;

  ParticlePainter(this.interface);

  @override
  void paint(Canvas canvas, Size size) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final delta = now - lastFrame;

    lastFrame = now;

    interface.backgroundPainters.forEach((element) => element(canvas, size));
    interface.layers.forEach((element) {
      element.before(canvas, size);
      element.particles.forEach((particle) {
        particle.step(delta / 1000.0, size);
        element.drawParticle(canvas, size, particle);
      });
      element.after(canvas, size);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

void saveBackground(Canvas canvas, Size size) {}

void clearBackground(Canvas canvas, Size size) {}

typedef void BackgroundPainter(Canvas canvas, Size size);

abstract class Particle {
  void step(double time, Size size);
}

abstract class ParticleLayer<T extends Particle> {
  List<T> get particles;
  void before(Canvas canvas, Size size);
  void after(Canvas canvas, Size size);
  void drawParticle(Canvas canvs, Size size, T particle);
}

abstract class Particles {
  final backgroundPainters = <BackgroundPainter>[clearBackground];
  final layers = <ParticleLayer>[LightingParticleLayer()];

  /// We are going to get the interface for the particles data here.

  static Particles get instance => DartBoardCore.instance.allFeatures
      .where((element) => element.namespace == "Particles") as Particles;
}

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
    t = t + (time * 5);
    x = size.width / 2 +
        cos((cw ? -1 : 1) * t * r) *
            min((r * r2) * (t * t) + (r + r2 + r3) * size.width * 2,
                t * 10 * (r + r2 + r3));
    y = size.height / 2 +
        sin((cw ? -1 : 1) * t * r2) *
            min((r2 * r3) * (t * t) + (r + r2 + r3) * size.height,
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
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = Colors.black);
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
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, particle.r / 50));
    canvas.restore();
  }

  @override
  List<LightingParticle> get particles => _particleList;
}
