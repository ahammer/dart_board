import 'package:dart_board_interface/dart_board_extension.dart';
import 'package:example/impl/my_home_page.dart';
import 'package:flutter/material.dart';

import 'impl/decorations/color_border_decoration.dart';
import 'impl/decorations/scaffold_appbar_decoration.dart';

class ExampleExtension implements DartBoardExtension {
  @override
  get routes => <RouteDefinition>[]..addMap({
      "/home": (ctx) => MyHomePage(),
      "/hello_world": (ctx) => Text("Welcome to the Example"),
      "/hello_world_2": (ctx) => Text("Welcome to the Example2")
    });

  @override
  get pageDecorations => <WidgetWithChildBuilder>[
        (context, child) => ScaffoldWithDrawerDecoration(child: child),
        (context, child) => DarkColorBorder(child: child)
      ];
}
