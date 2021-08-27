import 'dart:math';
import 'dart:ui';

import 'package:dart_board_canvas/dart_board_canvas.dart';
import 'package:flutter/material.dart';

class Draw100GreenCircles extends AnimatedCanvasState {
  final centers = List.generate(
      100,
      (index) => Offset(Random().nextDouble(), Random().nextDouble())
          .scale(0.75, 0.2)
          .translate(0.25 / 2, 0.40));

  final velocities = List.generate(
      100,
      (index) => Offset(Random().nextDouble(), Random().nextDouble())
          .translate(-0.5, -0.5)
          .scale(0.01, 0.01));

  @override
  void step(double deltaTime) {
    centers.replaceRange(0, centers.length, centers.map((e) {
      final idx = centers.indexOf(e);
      return e.translate(
          velocities[idx].dx * deltaTime, velocities[idx].dy * deltaTime);
    }));
    super.step(deltaTime);
  }

  @override
  void paint(Canvas canvas, Size size) {
    centers.forEach((element) {
      canvas.drawCircle(element.scale(size.width, size.height), 50,
          Paint()..color = Colors.black);
    });
  }
}
