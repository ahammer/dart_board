import 'package:dart_board_widgets/dart_board_widgets.dart';
import 'package:dart_board_core/dart_board_core.dart';
import 'package:dart_board_particles/presets/snow_particle.dart';
import 'package:dart_board_particles/dart_board_particle_feature.dart';
import 'package:flutter/material.dart';

final _particleLayer = SnowParticleLayer();

class SnowFeature extends DartBoardFeature {
  @override
  String get namespace => 'Snow';
  @override
  List<DartBoardFeature> get dependencies => [DartBoardParticleFeature()];

  @override
  List<DartBoardDecoration> get pageDecorations => [
        DartBoardDecoration(
            decoration: (BuildContext context, Widget child) => LifeCycleWidget(
                key: ValueKey(namespace + '_lifecycle'),
                init: (ctx) => Particles.instance.addLayer(_particleLayer),
                dispose: (ctx) =>
                    Particles.instance.removeLayer(_particleLayer),
                child: child),
            name: '${namespace}_overlay'),
      ];
}
