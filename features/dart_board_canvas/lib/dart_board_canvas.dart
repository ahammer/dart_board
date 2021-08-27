import 'package:dart_board_core/dart_board.dart';
import 'package:flutter/material.dart';

class DartBoardCanvasFeature<T extends AnimatedCanvasState>
    extends DartBoardFeature {
  /// Namespace this feature will take (it's flexible)
  final String namespace;

  /// Implementation Name of this feature
  final String implementationName;

  /// Route that will be exposed by this feature
  final String route;

  final T state;

  late final painter = CanvasFeaturePainter(state);
  late final widget = Container(
      width: double.infinity,
      height: double.infinity,
      child: LifeCycleWidget(
        //preInit: ,
        init: state.init,
        dispose: state.dispose,
        key: ValueKey(this),
        child: CustomPaint(painter: painter),
      ));

  DartBoardCanvasFeature({
    required this.namespace,
    required this.implementationName,
    required this.route,
    required this.state,
  });

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: route, builder: (context, settings) => widget)
      ];
}

class CanvasFeaturePainter extends CustomPainter {
  final AnimatedCanvasState state;

  CanvasFeaturePainter(this.state);

  @override
  void paint(Canvas canvas, Size size) {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final lastTime = state._lastFrameEpochMs;
    final deltaTime = (currentTime - lastTime) / 1000.0;
    state.step(deltaTime);
    return state.paint(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

/// This is a state object that tracks time.
/// Base class to track the state
abstract class AnimatedCanvasState {
  late int _lastFrameEpochMs;

  double _time = 0;
  double _timeDelta = 0;

  double get time => _time;
  double get timeDelta => _timeDelta;

  /// This will paint on the screen
  paint(Canvas canvas, Size size);

  @mustCallSuper
  void init(BuildContext context) =>
      _lastFrameEpochMs = DateTime.now().millisecondsSinceEpoch;

  void dispose(BuildContext context) {}

  @mustCallSuper
  void step(double deltaTime) {
    _time += deltaTime;
    _timeDelta = deltaTime;
  }
}
