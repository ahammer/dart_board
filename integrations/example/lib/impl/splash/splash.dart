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
const res = 10;
const tweenTime = 5;

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
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            ' Dart Board',
            style: Theme.of(context)
                .textTheme
                .headline1!
                .copyWith(fontWeight: FontWeight.bold),
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
  final List<int> shuffled = List.generate(res * res, (index) => index)
    ..shuffle();

  late final List<_Box> boxes = List.generate(
      res * res,
      (index) => _Box(
            target: Offset((index % res).toDouble(), (index ~/ res).toDouble())
                .scale(1 / res, 1 / res)
                .translate(-0.5, -0.5),
            origin: Offset((shuffled[index] % res).toDouble(),
                    (shuffled[index] ~/ res).toDouble())
                .scale(1 / res, 1 / res)
                .translate(-0.5, -0.5)
                .scale(res / 2, res / 2),
          ));

  @override
  void paint(Canvas canvas, Size size) {
    final longestSide = max(size.width, size.height);
    final squareWidth = longestSide / res * 1.5;
    final animTime = min(time / tweenTime, 1.0).toDouble();
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = Colors.white.withOpacity((1 - animTime) / 5 + 0.78));
    boxes.forEach((box) {
      final curOffset = box.tweenPos.transform(curve.transform(animTime));
      canvas.save();
      canvas.translate(
          curOffset.dx * longestSide + size.width / 2 + squareWidth / 2,
          curOffset.dy * longestSide + size.height / 2 + squareWidth / 2);
      if (animTime >= 1) {
        canvas.rotate((time - tweenTime) / 2);
      } else {
        /// Tween into position
        canvas.rotate(box.tweenRot.transform(animTime));
      }

      final tweenScale = box.tweenScale.transform(animTime);
      canvas.scale(squareWidth * tweenScale, squareWidth * tweenScale);
      canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: 1, height: 1),
          Paint()
            ..color = box.getColor(this)
            ..blendMode = BlendMode.overlay);
      canvas.restore();
    });
  }
}

// Random Kernel
// Used to generate "Perlin noise"
final _ki = [
  Random().nextInt(20),
  Random().nextInt(20),
  Random().nextInt(20),
  Random().nextInt(20),
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

  final double r = Random().nextDouble();
  final double g = Random().nextDouble();
  final double b = Random().nextDouble();

  late final tweenPos = Tween<Offset>(begin: origin, end: target);
  late final tweenRot = Tween<double>(begin: initialRotation, end: 0);
  late final tweenScale = Tween<double>(begin: 0.0, end: 1.0);
  late final delta = target - origin;
  Color getColor(AnimatedCanvasState state) {
    final a = (cos(target.dx * _ki[0] + state.time) + 1) / 2;
    final b = (cos(target.dy * _ki[1] + state.time) + 1) / 2;
    final c = (cos(target.dx * _ki[2] + state.time) + 1) / 2;
    final d = (cos(target.dy * _ki[3] + state.time) + 1) / 2;

    final e = (cos(target.dx * _ki[4] + state.time) + 1) / 2;
    final f = (cos(target.dy * _ki[5] + state.time) + 1) / 2;
    final g = (cos(target.dx * _ki[6] + state.time) + 1) / 2;
    final h = (cos(target.dy * _ki[7] + state.time) + 1) / 2;

    // Luminace, Opacity
    final l = ((e + f + g + h) / 4 * 255).toInt();
    final o = (a + b + c + d) / 4;

    return Color.fromRGBO((l * r).toInt(), (l * g).toInt(), (l * b).toInt(), o);
  }

  _Box({required this.target, required this.origin});
}
