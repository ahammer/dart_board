import 'dart:io';

import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_particles/presets/fire_particle.dart';
import 'package:dart_board_particles/dart_board_particle_feature.dart';
import 'package:dart_board_particles/presets/rainbow_particle.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class CursorFeature extends DartBoardFeature {
  ParticleLayer generateParticleLayer(double x, double y);

  @override
  List<DartBoardFeature> get dependencies => [DartBoardParticleFeature()];

  @override
  List<DartBoardDecoration> get pageDecorations => [
        /// For Mouse-enabled platforms we'll use MouseRegion
        if (kIsWeb ||
            Platform.isLinux ||
            Platform.isWindows ||
            Platform.isMacOS)
          DartBoardDecoration(
              decoration: (BuildContext context, Widget child) => MouseRegion(
                    key: ValueKey('${namespace}_mouse_region'),
                    onHover: (hover) {
                      if (hover.position.dx != 0 && hover.position.dy != 0)
                        return Particles.instance.addLayer(
                            generateParticleLayer(
                                hover.position.dx, hover.position.dy));
                    },
                    child: child,
                  ),
              name: '${namespace}_overlay')
        else
          DartBoardDecoration(
              decoration: (BuildContext context, Widget child) =>
                  GestureDetector(
                    excludeFromSemantics: true,
                    key: ValueKey('${namespace}_mouse_region'),
                    onPanUpdate: (hover) {
                      if (hover.globalPosition.dx != 0 &&
                          hover.globalPosition.dy != 0)
                        return Particles.instance.addLayer(
                            generateParticleLayer(hover.globalPosition.dx,
                                hover.globalPosition.dy));
                    },
                    child: child,
                  ),
              name: '${namespace}_overlay'),
      ];
}

/// Add a flame to your cursor
class FireCursorFeature extends CursorFeature {
  @override
  String get namespace => 'FireCursor';
  @override
  ParticleLayer<Particle> generateParticleLayer(double x, double y) =>
      FireParticleLayer(x, y);
}

/// Add a rainbow to your cursor
class RainbowCursorFeature extends CursorFeature {
  double? oldY;
  double? oldX;

  @override
  String get namespace => 'RainbowCursor';
  @override
  ParticleLayer<Particle> generateParticleLayer(double x, double y) {
    final layer = RainbowParticleLayer(x, y, oldX ?? x, oldY ?? y);
    oldX = x;
    oldY = y;

    return layer;
  }
}
