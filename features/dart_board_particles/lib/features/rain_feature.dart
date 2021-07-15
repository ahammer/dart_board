import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_particles/presets/water_particle.dart';
import 'package:dart_board_particles/dart_board_particle_feature.dart';

class RainFeature extends DartBoardFeature {
  @override
  String get namespace => 'Rainfall';
  @override
  List<DartBoardFeature> get dependencies => [DartBoardParticleFeature()];

  @override
  List<DartBoardDecoration> get pageDecorations => [
        DartBoardDecoration(
            decoration: (BuildContext context, Widget child) => LifeCycleWidget(
                key: ValueKey(namespace + '_lifecycle'),
                init: (ctx) {
                  Particles.instance.addLayer(WaterParticleLayer());
                },
                child: child),
            name: '${namespace}_overlay'),
      ];
}
