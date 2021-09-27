import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_theme/theme_chooser.dart';
import 'package:flutter/material.dart';

import 'theme_builder.dart';

class ThemeFeature extends DartBoardFeature with ChangeNotifier {
  @override
  String get implementationName => 'Theme';

  ThemeData data;

  ThemeData Function(ThemeData data)? middleware;

  ThemeFeature({required this.data, this.middleware});

  @override
  List<DartBoardDecoration> get pageDecorations => [
        DartBoardDecoration(
          name: 'theme_applicator',
          decoration: (context, child) => ChangeNotifierBuilder<ThemeFeature>(
              notifier: this,
              builder: (ctx, feature) => Theme(
                    data: middleware != null ? middleware!(data) : data,
                    child: child,
                  )),
        ),
      ];

  @override
  // setTheme
  // argument "themeData" = The data to apply
  //
  Map<String, MethodCallHandler> get methodHandlers => {
        'setThemeData': (ctx, call) async {
          if (call.arguments['themeData'] is ThemeData) {
            data = call.arguments['themeData'];
            notifyListeners();
            return true;
          }
          return false;
        },
        'showThemeChooser': (ctx, call) async {
          return await showDialog(
              context: ctx,
              builder: (ctx) => ThemeChooser(),
              useSafeArea: true);
        }
      };

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: '/theme_editor', builder: (ctx, settings) => ThemeBuilder()),
      ];

  @override
  String get namespace => 'Theme';
}
