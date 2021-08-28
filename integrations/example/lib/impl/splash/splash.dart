import 'dart:math';
import 'dart:ui';

import 'package:dart_board_canvas/dart_board_canvas.dart';
import 'package:dart_board_core/dart_board.dart';
import 'package:flutter/material.dart';

/// Sometimes you just want to be quick and dirty
///
/// This splash was built like this
///
/// 1. Added centered text (title)
/// 2. Created an AnimatedCanvasState we can mount to a route
/// 3. Put that route in a stack z-below the text
const curve = Curves.easeInOutCubic;

class ExampleSplashWidget extends StatelessWidget {
  const ExampleSplashWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // We bring the
        RouteWidget('/splash_bg'),
        Center(
          child: Text(
            'Dart Board',
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
      ],
    );
  }
}

/// We are going to use this AnimatedCanvasState to draw the boxes
/// It's mounted with
///
///   DartBoardCanvasFeature(
///     state: SplashCanvas(),
///     namespace: 'splash_background',
///     implementationName: 'static',
///     route: '/splash_bg',
///   ),
///
/// And then displayed using "/splash_bg" route.

class SplashAnimation extends AnimatedCanvasState {
  final List<int> shuffled = List.generate(20 * 20, (index) => index)
    ..shuffle();

  late final List<_Box> boxes = List.generate(
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
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = Colors.white.withOpacity((1 - animTime) / 5 + 0.78));
    boxes.forEach((box) {
      final curOffset = box.tweenPos.transform(curve.transform(animTime));
      canvas.save();
      canvas.translate(
          curOffset.dx * longestSide + size.width / 2 + squareWidth / 2,
          curOffset.dy * longestSide + size.height / 2 + squareWidth / 2);
      canvas.rotate(box.tweenRot.transform(animTime));
      final tweenScale = box.tweenScale.transform(animTime);
      canvas.scale(squareWidth * tweenScale, squareWidth * tweenScale);
      canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: 1, height: 1),
          Paint()..color = box.getColor(this));
      canvas.restore();
    });
  }
}

// Random Kernel
final _kd = [
  Random().nextDouble(),
  Random().nextDouble(),
  Random().nextDouble(),
  Random().nextDouble(),
];
final _ki = [
  Random().nextInt(20),
  Random().nextInt(20),
  Random().nextInt(20),
  Random().nextInt(20),
];

/// One box that we render

class _Box {
  final Offset target;
  final Offset origin;
  final double initialRotation = Random().nextDouble() - 0.5 * 20;

  late final tweenPos = Tween<Offset>(begin: origin, end: target);
  late final tweenRot = Tween<double>(begin: initialRotation, end: 0);
  late final tweenScale = Tween<double>(begin: 0.0, end: 1.0);
  late final delta = target - origin;
  Color getColor(AnimatedCanvasState state) {
    final a = (cos(target.dx * _ki[0] + state.time) + 1) / 2;
    final b = (cos(target.dx * 10) + 1) / 2;

    return Colors.red.withOpacity(a);
  }

  _Box({required this.target, required this.origin});
}
