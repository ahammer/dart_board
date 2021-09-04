import 'package:dart_board_core/dart_board.dart';
import 'package:flutter/material.dart';

import 'clocks/clock_scaffolding.dart';
import 'customizer.dart';

class SpaceClockFeature extends DartBoardFeature {
  final String namespace;
  final String route;
  final String implementationName;

  final bool showMoon;
  final bool showEarth;
  final bool showSun;

  SpaceClockFeature({
    this.showMoon = false,
    this.showEarth = true,
    this.showSun = false,
    this.namespace = "clock",
    this.route = "/clock",
    this.implementationName = "default",
  });

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            builder: (ctx, settings) => ClockCustomizer((model) => Builder(
                builder: (context) => ClockScaffolding(
                      model: model,
                      showMoon: showMoon,
                      showSun: showSun,
                      showEarth: showEarth,
                    ))),
            route: route)
      ];
}
