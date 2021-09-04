import 'package:flutter/material.dart';

import '../model.dart';
import 'space/space_clock.dart';
import 'ticker/ticker_clock.dart';

///
/// The scaffolding of this clock
///
/// It's a Stack
/// Layer 1: The space scene
/// Layer 2: The DateTimeAndWeatherTicker the draws in the top left
///
class ClockScaffolding extends StatelessWidget {
  final bool showMoon, showEarth, showSun;

  /// Construct a clock scaffolding given a model
  ///
  const ClockScaffolding({
    required this.model,
    Key? key,
    this.showMoon = false,
    this.showEarth = true,
    this.showSun = false,
  }) : super(key: key);

  /// The ClockModel, needed by things to make decisions about what to draw
  final ClockModel model;

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          //The space clock
          SpaceClockScene(
            model,
            showMoon: showMoon,
            showSun: showSun,
            showEarth: showEarth,
          ),

          Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: DateTimeAndWeatherTicker(clockModel: model),
              )),
        ],
      );
}
