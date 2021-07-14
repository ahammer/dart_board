import 'package:dart_board_core/interface/dart_board_interface.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// This is an App decoration for particle effects
/// It'll overlay all your screens and give you access to a full screen canvas
class DartBoardParticleFeature extends DartBoardFeature with Particles {
  static final DartBoardParticleFeature _singleton =
      DartBoardParticleFeature._internal();

  factory DartBoardParticleFeature() => _singleton;

  DartBoardParticleFeature._internal();
  @override
  String get namespace => "Particles";

  @override
  List<DartBoardDecoration> get appDecorations => [
        DartBoardDecoration(
            name: "ParticleLayer",
            decoration: (context, child) => DartBoardParticleDecoration(
                  key: ValueKey("ParticleLayer"),
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

    interface._backgroundPainters.forEach((element) => element(canvas, size));
    interface._layers.forEach((element) {
      element.step(delta / 1000.0);
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
  double time = 0.0;
  List<T> get particles;
  void before(Canvas canvas, Size size);
  void after(Canvas canvas, Size size);
  void drawParticle(Canvas canvs, Size size, T particle);

  /// Track the time a Layer has been active
  void step(double d) {
    time = time + d;
  }
}

abstract class Particles {
  final _backgroundPainters = <BackgroundPainter>[clearBackground];
  final _layers = <ParticleLayer>[];

  /// We are going to get the interface for the particles data here.

  static Particles get instance => DartBoardCore.instance.allFeatures
      .where((element) => element.namespace == "Particles")
      .first as Particles;

  void addLayer(ParticleLayer layer) => _layers.add(layer);
}
