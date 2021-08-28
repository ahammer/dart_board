import 'dart:math';
import 'dart:ui';

import 'package:dart_board_canvas/dart_board_canvas.dart';
import 'package:flutter/material.dart';

const curve = Curves.easeInOutCubic;

class _Box {
  final Offset target;
  final Offset origin;
  final double initialRotation = Random().nextDouble() - 0.5 * 20;
  late final tweenPos = Tween<Offset>(begin: origin, end: target);
  late final tweenRot = Tween<double>(begin: initialRotation, end: 0);
  late final delta = target - origin;
  late final color =
      HSLColor.fromAHSL(1.0, cos(target.dx + target.dy) * 5000 % 360, 0.5, 0.8)
          .toColor();

  _Box({required this.target, required this.origin});
}

late final List<int> shuffled = List.generate(20 * 20, (index) => index)
  ..shuffle();

class IntroBoxes extends AnimatedCanvasState {
  /// Shuffled Indexes

  final List<_Box> boxes = List.generate(
      20 * 20,
      (index) => _Box(
            target: Offset(index % 20, (index ~/ 20).toDouble())
                .scale(1 / 20, 1 / 20)
                .translate(-0.5, -0.5),
            origin:
                Offset(shuffled[index] % 20, (shuffled[index] ~/ 20).toDouble())
                    .scale(1 / 20, 1 / 20)
                    .translate(-0.5, -0.5)
                    .scale(10, 10),
          ));

  @override
  void paint(Canvas canvas, Size size) {
    final longestSide = max(size.width, size.height);
    final squareWidth = longestSide / 20.0 + 1;
    final animTime = min(time / 4.0, 1.0).toDouble();
    boxes.forEach((box) {
      final curOffset = box.tweenPos.transform(curve.transform(animTime));
      canvas.save();
      canvas.translate(
          curOffset.dx * longestSide + size.width / 2 + squareWidth / 2,
          curOffset.dy * longestSide + size.height / 2 + squareWidth / 2);
      canvas.rotate(box.tweenRot.transform(animTime));
      canvas.scale(squareWidth, squareWidth);
      canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: 1, height: 1),
          Paint()..color = box.color);
      canvas.restore();
    });
  }
}
