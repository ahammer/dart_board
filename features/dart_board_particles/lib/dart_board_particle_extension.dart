import 'package:dart_board_core/interface/dart_board_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// This is an App decoration for particle effects
/// It'll overlay all your screens and give you access to a full screen canvas
class DartBoardParticleFeature extends DartBoardFeature implements Particles {
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
    extends State<DartBoardParticleDecoration> {
  late final ParticlePainter painter;
  @override
  void initState() {
    super.initState();
    painter = ParticlePainter(widget.interface);
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          widget.child,
          IgnorePointer(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: CustomPaint(
                painter: painter,
                willChange: true,
              ),
            ),
          )
        ],
      );
}

class ParticlePainter extends CustomPainter {
  final Particles interface;

  ParticlePainter(this.interface);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset(0, 0), Offset(size.width, size.height),
        Paint()..color = Colors.green);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

abstract class Particles {
  /// We are going to get the interface for the particles data here.

  static Particles get instance => DartBoardCore.instance.allFeatures
      .where((element) => element.namespace == "Particles") as Particles;
}
