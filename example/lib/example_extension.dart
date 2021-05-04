import 'package:dart_board_interface/dart_board_extension.dart';
import 'package:example/impl/decorations/animated_background_decoration.dart';
import 'package:example/impl/pages/example_construction.dart';

import 'package:example/impl/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'impl/decorations/color_border_decoration.dart';
import 'impl/decorations/scaffold_appbar_decoration.dart';
import 'impl/pages/about.dart';

class ExampleExtension implements DartBoardExtension {
  @override
  get routes => <RouteDefinition>[]..addMap({
      "/": (ctx) => HomePage(),
      "/about": (ctx) => AboutPage(),
      "/example": (ctx) => ExampleConstruction()
    });

  @override
  get pageDecorations => <WidgetWithChildBuilder>[
        (context, child) => ScaffoldWithDrawerDecoration(child: child),
        (context, child) => DarkColorBorder(child: child),
        (context, child) => AnimatedBackgroundDecoration(
              color: Theme.of(context).accentColor,
              child: child,
            )
      ];
}
