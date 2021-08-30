import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:dart_board_canvas/dart_board_canvas.dart';
import 'package:dart_board_core/dart_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Sometimes you just want to be quick and dirty, this is demo programming at heart
/// Don't use this file as a example on how to code for business
///
/// I'm just having fun here, don't expect documentation or good patterns
const _curve = Curves.easeInOutCubic;
const _res = 8;
const _tweenTime = 5;

class ExampleSplashWidget extends StatelessWidget {
  const ExampleSplashWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (ctx, constraints) => Stack(
          children: [
            RouteWidget('/splash_bg'),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 0, 0),
              child: Text(
                'Dart Board',
                style: Theme.of(context).textTheme.headline1!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      BoxShadow(
                          color: Colors.black,
                          blurRadius: 10,
                          offset: Offset(5, 5))
                    ]),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: MaterialButton(
                onPressed: () {
                  DartBoardCore.instance.dispatchMethodCall(
                      context: context, call: MethodCall('hideSplashScreen'));
                },
                child: Text('Dismiss Splash'),
              ),
            )
          ],
        ),
      );
}

class SplashAnimation extends AnimatedCanvasState {
  final List<int> shuffled = List.generate(_res * _res, (index) => index)
    ..shuffle();

  late final List<_Box> boxes = List.generate(
      _res * _res,
      (index) => _Box(
          target: Offset((index % _res).toDouble(), (index ~/ _res).toDouble())
              .scale(1 / _res, 1 / _res)
              .translate(-0.5, -0.5),
          origin: Offset((shuffled[index] % _res).toDouble(),
                  (shuffled[index] ~/ _res).toDouble())
              .scale(1 / _res, 1 / _res)
              .translate(-0.5, -0.5)
          //.scale(_res / 2, _res / 2),
          ));

  @override
  void paint(Canvas canvas, Size size) {
    final longestSide = max(size.width, size.height);
    final squareWidth = longestSide / _res * 2.0;
    final animTime = min(time / _tweenTime, 1.0).toDouble();
    final fadeTime = max(0.0, 1.0 - max(0.0, (time - 5) / 2.0));

    canvas.drawRect(
        Rect.fromLTRB(0, 0, size.width, size.height),
        Paint()
          ..color = HSLColor.fromAHSL(
                  (1.0 - (animTime / 3)), animTime * 360, 0.8, 0.7)
              .toColor());

    boxes.forEach((box) {
      var transform = _curve.transform(animTime);
      final curOffset = box.tweenPos.transform(transform);
      canvas.save();
      canvas.translate(
          curOffset.dx * longestSide + size.width / 2 + squareWidth / 2,
          curOffset.dy * longestSide + size.height / 2 + squareWidth / 2);

      /// Tween into position
      canvas.rotate(box.tweenRot.transform(animTime) + time);

      final tweenScale = box.tweenScale.transform(transform);
      final c = box.getColor(this);
      canvas.scale(squareWidth * tweenScale * c.opacity * fadeTime,
          squareWidth * tweenScale * c.opacity * fadeTime);
      canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: 1, height: 1),
          Paint()
            ..color = c
            ..blendMode = BlendMode.difference);
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
  final double initialRotation = -5;

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
