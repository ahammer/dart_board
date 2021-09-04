import 'package:dart_board_core/dart_board.dart';
import 'package:flutter/material.dart';

import 'clocks/clock_scaffolding.dart';
import 'customizer.dart';

class ClockFeature extends DartBoardFeature {
  final String namespace;
  final String route;
  final String implementationName;

  ClockFeature({
    this.namespace = "clock",
    this.route = "/clock",
    this.implementationName = "default",
  });

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            builder: (ctx, settings) => ClockCustomizer((model) =>
                Builder(builder: (context) => ClockScaffolding(model: model))),
            route: route)
      ];
}
