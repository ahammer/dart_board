import 'package:dart_board/impl/dart_board_core.dart';
import 'package:dart_board_debug_extension/debug_extension.dart';
import 'package:dart_board_interface/dart_board_extension.dart';
import 'package:dart_board_log_extension/log_extension.dart';
import 'package:dart_board_theme_extension/theme_extension.dart';
import 'package:example/impl/decorations/animated_background_decoration.dart';
import 'package:example/impl/pages/home_page.dart';
import 'package:example/impl/routes/custom_routes.dart';
import 'package:flutter/material.dart';
import 'impl/decorations/color_border_decoration.dart';
import 'impl/decorations/scaffold_appbar_decoration.dart';
import 'impl/pages/about.dart';

/// The Example Extension
class ExampleExtension extends DartBoardExtension {
  @override
  List<RouteDefinition> get routes => <RouteDefinition>[
        NamedRouteDefinition(
            routeBuilder: kSpinRoute,
            route: '/home',
            builder: (ctx, settings) => HomePage()),
        NamedRouteDefinition(
            route: '/about', builder: (ctx, settings) => AboutPage()),
      ];

  /// These are page-scoped decorations
  @override
  List<PageDecoration> get pageDecorations => <PageDecoration>[
        /// The AppBar and Nav Drawer
        PageDecoration(
            name: 'scaffold_and_drawer',
            decoration: (context, child) => ScaffoldWithDrawerDecoration(
                child: DarkColorBorder(child: child))),

        /// The animated background effect
        PageDecoration(
            name: 'animated_background',
            decoration: (context, child) => AnimatedBackgroundDecoration(
                  color: Theme.of(context).accentColor,
                  child: child,
                ))
      ];

  /// These are app-level decorations (not needed here)
  @override
  List<WidgetWithChildBuilder> get appDecorations => [];

  @override
  List<DartBoardExtension> get dependencies =>
      [ThemeExtension(), DebugExtension(), LogExtension()];

  @override
  List<String> get pageDecorationDenyList => ['/log:scaffold_and_drawer'];

  @override
  String get namespace => 'example';
}
