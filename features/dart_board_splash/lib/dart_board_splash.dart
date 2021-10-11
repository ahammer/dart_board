import 'dart:async';
import 'package:dart_board_widgets/dart_board_widgets.dart';
import 'package:dart_board_core/dart_board_core.dart';
import 'package:dart_board_core/interface/dart_board_interface.dart';
import 'package:dart_board_locator/dart_board_locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Splash Feature
///
/// Simple Splash Feature.
/// Include this to add a Splash to your App
/// Splash can either hide itself (after a timer)
///
/// Usage:
/// ```
///   *ADD TO YOUR REGISTRATION*
///   DartBoardSplashFeature(YourSplashWidget),
///
///   *HIDE FROM ANYWHERE IN YOUR CODE*
///
///   DartBoardCore.instance.dispatchMethodCall(
///     context: context,
///     call: MethodCall("hideSplashScreen"));
/// ```
///
class DartBoardSplashFeature extends DartBoardFeature {
  final Widget splashWidget;

  DartBoardSplashFeature(this.splashWidget);

  @override
  String get namespace => "SplashScreen";

  @override
  List<DartBoardDecoration> get appDecorations => [
        LocatorDecoration(() => _SplashState()),
        DartBoardDecoration(
            name: "SplashLifeCycle",
            decoration: (ctx, child) => _SplashDecoration(
                  splashWidget: splashWidget,
                  child: child,
                )),
      ];

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: "/splash_screen", builder: (ctx, settings) => splashWidget)
      ];

  @override
  List<DartBoardFeature> get dependencies => [DartBoardLocatorFeature()];

  @override
  Map<String, MethodCallHandler> get methodHandlers => {
        "hideSplashScreen": (ctx, call) async {
          locate<_SplashState>()._hide();
        },
        "showSplashScreen": (ctx, call) async {
          locate<_SplashState>()._restart();
        }
      };
}

/// App Decoration Widget for the Splash Screen
class _SplashDecoration extends StatelessWidget {
  final Widget child;
  const _SplashDecoration({
    Key? key,
    required this.splashWidget,
    required this.child,
  }) : super(key: key);

  final Widget splashWidget;

  @override
  Widget build(BuildContext context) => locate<_SplashState>()
      .builder<_SplashState>((ctx, state) => !state._visible
          ? child
          : Stack(children: [
              child,
              splashWidget,
            ]));
}

class _SplashState extends ChangeNotifier {
  bool _visible = true;

  void _hide() {
    _visible = false;
    notifyListeners();
  }

  void _restart() {
    _visible = true;
    notifyListeners();
  }
}

/// A very simple fading out Splash Screen
///
/// Can be used as an example to build your own
/// If you want to isolate the splash into it's own feature you
/// can use RouteWidget to wire it up into a Splash.
///
/// delay - how long it'll show
/// fadeDuration - how long the duration is
///
class FadeOutSplashScreen extends StatefulWidget {
  final Duration delay;
  final Duration fadeDuration;
  final WidgetBuilder contentBuilder;

  const FadeOutSplashScreen(
      {Key? key,
      required this.contentBuilder,
      this.delay = const Duration(seconds: 1),
      this.fadeDuration = const Duration(seconds: 1)})
      : super(key: key);

  @override
  _FadeOutSplashScreenState createState() => _FadeOutSplashScreenState();
}

class _FadeOutSplashScreenState extends State<FadeOutSplashScreen> {
  late final child = widget.contentBuilder(context);
  bool startedFade = false;
  @override
  void initState() {
    super.initState();
    Timer(widget.delay, () {
      setState(() => startedFade = true);
    });
  }

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
        opacity: startedFade ? 0 : 1,
        curve: Curves.easeInOut,
        onEnd: () {
          context.dispatchMethod("hideSplashScreen");
        },
        duration: widget.fadeDuration,
        child: Container(
            width: double.infinity, height: double.infinity, child: child),
      );
}
