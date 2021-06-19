import 'package:flutter/material.dart';

/// Material
Route kFadeRouteBuilder(RouteSettings settings, WidgetBuilder builder) =>
    PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = 0.0;
        var end = 1.0;

        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return FadeTransition(
          opacity: animation.drive(tween),
          child: child,
        );
      },
    );

Route kSpinRoute(RouteSettings settings, WidgetBuilder builder) =>
    PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = 0.0;
        var end = 1.0;
        var curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return FadeTransition(
            opacity: animation.drive(tween),
            child: ScaleTransition(
                scale: animation.drive(tween),
                child: RotationTransition(
                  turns: animation.drive(tween),
                  child: child,
                )));
      },
    );
