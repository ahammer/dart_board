# dart_board_splash

Splash Screen Module for Dart-Board

## Getting Started

Include your feature

`DartBoardSplashFeature(this.splashWidget)`

splashWidget should be a widget that dispatches.

`hideSplashScreen`
e.g.
```
DartBoardCore.instance.dispatchMethodCall(
    context: context, call: MethodCall("hideSplashScreen"));
```

There is a built in one to show content and then fade it out.

```
class FadeOutSplashScreen extends StatefulWidget {
  final Duration delay;
  final Duration fadeDuration;
  final WidgetBuilder contentBuilder;
```

`delay` = The time the Splash is shown for
`fadeDuration` = The time the fade occurs for
`contentBuilder` = What you want to show. E.g. a white screen with logo, some ducks crossing the screen, whatever.
Any widget really, interactive or not.
