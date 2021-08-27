import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

void draw100GreenCircles(Canvas canvas, Size size) {
  final r = Random();

  for (var i = 0; i < 100; i++) {
    canvas.drawCircle(
        Offset(r.nextDouble() * size.width, r.nextDouble() * size.height),
        100,
        Paint()..color = Colors.green);
  }
}
