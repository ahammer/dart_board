import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_core/interface/dart_board_interface.dart';
import 'package:dart_board_locator/dart_board_locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DartBoardSplashFeature extends DartBoardFeature {
  final Widget splashWidget = FadeOutSplashScreen();

  @override
  String get namespace => "SplashScreen";

  @override
  List<DartBoardDecoration> get appDecorations => [
        DartBoardDecoration(
            name: "SplashLifeCycle",
            decoration: (ctx, child) => SplashDecoration(
                  splashWidget: splashWidget,
                  child: child,
                )),
        LocatorDecoration(() => SplashScreenMessenger())
      ];

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: "/splash_screen", builder: (ctx, settings) => splashWidget)
      ];
}

class SplashDecoration extends StatelessWidget {
  final Widget child;
  const SplashDecoration({
    Key? key,
    required this.splashWidget,
    required this.child,
  }) : super(key: key);

  final Widget splashWidget;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [child, splashWidget],
    );
  }
}

class SplashScreenMessenger extends ChangeNotifier {
  bool _visible = true;
  void _hide() {
    _visible = false;
    notifyListeners();
  }
}

class FadeOutSplashScreen extends StatefulWidget {
  @override
  _FadeOutSplashScreenState createState() => _FadeOutSplashScreenState();
}

class _FadeOutSplashScreenState extends State<FadeOutSplashScreen> {
  bool startedFade = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      setState(() => startedFade = true);
    });
  }

  @override
  Widget build(BuildContext context) => AnimatedOpacity(
        opacity: startedFade ? 0 : 1,
        duration: Duration(seconds: 5),
        child: Material(
          child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Text("blah")),
        ),
      );
}
