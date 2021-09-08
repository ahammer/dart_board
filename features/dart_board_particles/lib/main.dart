import 'dart:math';

import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_core/impl/widgets/timer_widgets.dart';
import 'package:dart_board_particles/dart_board_particle_feature.dart';
import 'package:dart_board_particles/features/cursor_particle_features.dart';
import 'package:dart_board_particles/presets/fire_particle.dart';
import 'package:dart_board_particles/presets/lighting_particle.dart';
import 'package:dart_board_particles/presets/rainbow_particle.dart';
import 'package:dart_board_particles/presets/snow_particle.dart';
import 'package:flutter/material.dart';

/// Dart Board Particles Example
void main() => runApp(DartBoard(
      initialRoute: '/home',
      features: [
        SimpleRouteFeature(),

        /// We are going to use the Particle Feature
        DartBoardParticleFeature()

          /// Add the Snow Layer (it's persistent)
          ..addLayer(SnowParticleLayer())

          /// And show the intro particle layer
          ..addLayer(LightingParticleLayer()),

        FireCursorFeature(),
        RainbowCursorFeature()
      ],
    ));

/// The screen/layout for the example
class SimpleRouteFeature extends DartBoardFeature {
  @override
  String get namespace => 'main_page';

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: '/home',
            builder: (ctx, settings) => Material(
                  color: Color.fromARGB(255, 48, 48, 72),
                  child: LayoutBuilder(
                    builder: (ctx, constraints) => PeriodicWidget(
                        callback: (idx) {
                          final t =
                              DateTime.now().millisecondsSinceEpoch / 500.0;
                          final w = constraints.maxWidth;
                          final h = constraints.maxHeight;

                          final hw = w / 2;
                          final hh = h / 2;
                          final r = min(hw, hh) * 0.8;

                          Particles.instance.addLayer(FireParticleLayer(
                            cos(t) * r + hw,
                            sin(t) * r + hh,
                          ));

                          Particles.instance.addLayer(RainbowParticleLayer(
                            cos(t + 3.15) * r + hw,
                            sin(t + 3.15) * r + hh,
                            cos((t - 1) + 3.15) * r + hw,
                            sin((t - 1) + 3.15) * r + hh,
                          ));
                        },
                        duration: Duration(milliseconds: 1),
                        child: Container()),
                  ),
                )),
      ];
}
