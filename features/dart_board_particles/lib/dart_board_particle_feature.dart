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
    _controller.repeat(min: 1, max: 2);
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

    interface._layers.forEach((element) {
      element.step(delta / 1000.0);
      if (!element.isDead) {
        if (element.needsBefore) element.before(canvas, size);
        element.particles.forEach((particle) {
          particle.step(delta / 1000.0, size);
          if (element.needsParticlePaint)
            element.drawParticle(canvas, size, particle);
        });
        if (element.needsAfter) element.after(canvas, size);
      }
    });

    // Clean dead layers
    interface._layers.removeWhere((element) => element.isDead);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

typedef void BackgroundPainter(Canvas canvas, Size size);

abstract class Particle {
  void step(double time, Size size);
}

/// A "Layer" of particles. Represents a fixed number of particles on the screen
///
/// Remove a layer by marking it dead (return true in isDead)
abstract class ParticleLayer<T extends Particle> {
  /// Current runtime of this layer
  double time = 0.0;

  /// Particles we are going to render
  List<T> get particles;

  /// Has this layer died yet? True will automatically be pruned
  bool get isDead;

  /// To optimize I'll provide these options
  /// Not all system need before/after and per-particle paint
  ///
  /// E.g. if you use drawPoints you might just need before.
  /// If you don't compose or saveLayer() you might only need
  /// particle paint.
  ///
  /// All enabled by default
  bool get needsBefore => true;
  bool get needsAfter => true;
  bool get needsParticlePaint => true;

  /// Before we draw this layer
  void before(Canvas canvas, Size size);

  /// During
  void drawParticle(Canvas canvs, Size size, T particle);

  /// After we draw this layer
  void after(Canvas canvas, Size size);

  /// Track the time a Layer has been active
  void step(double d) => time += d;
}

/// The interface and code for the Particles layer itself
/// we apply this to the Extension for easy access. It's also a singleton
/// by design.
abstract class Particles {
  final _layers = <ParticleLayer>[];

  /// We are going to get the interface for the particles data here.

  static Particles get instance => DartBoardParticleFeature();

  /// Add a layer
  void addLayer(ParticleLayer layer) => _layers.add(layer);

  /// Remove a layer
  void removeLayer(ParticleLayer layer) => _layers.remove(layer);
}
