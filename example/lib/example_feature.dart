import 'dart:io';

import 'package:dart_board/dart_board.dart';
import 'package:dart_board_minesweeper/minesweeper_feature.dart';
import 'package:dart_board_theme/theme_feature.dart';
import 'package:dart_board_debug/debug_feature.dart';
import 'package:dart_board_log/log_feature.dart';
import 'package:example/impl/pages/code_overview.dart';
import 'data/constants.dart';
import 'impl/decorations/color_border_decoration.dart';
import 'impl/decorations/wavy_lines_background.dart';
import 'impl/pages/home_page.dart';
import 'package:dart_board_template_bottomnav/bottom_nav_template.dart';
import 'impl/pages/haiku_and_code.dart';
import 'impl/routes/custom_routes.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// The Example Feature
///
/// A feature is a set of capabilities you would like to add to an app.
/// For this example, we re going to provide a few things.
///
/// 1) Routes
/// 2) Page Decorations and Config
/// 3) Feature Dependencies
class ExampleFeature extends DartBoardFeature {
  /// These are the Routes were are going to Provide.
  ///
  /// We can use the NamedRouteDefinition() to provide
  /// simple named routes
  ///
  /// We can also apply custom route builders, e.g. the Spin
  /// applied to the /home route
  @override
  List<RouteDefinition> get routes => <RouteDefinition>[
        NamedRouteDefinition(
            routeBuilder: kSpinRoute,
            route: '/home',
            builder: (ctx, settings) => HomePage()),
        NamedRouteDefinition(
            route: '/code', builder: (ctx, settings) => CodeOverview()),
        ...kCodeRoutes.map((e) => NamedRouteDefinition(
            route: e['route']!,
            builder: (ctx, setting) =>
                HaikuAndCode(haiku: e['haiku']!, url: e['url']!))),
      ];

  /// These are page-scoped decorations
  @override
  List<DartBoardDecoration> get pageDecorations => <DartBoardDecoration>[
        DartBoardDecoration(
            name: 'color_border',
            decoration: (context, child) => DarkColorBorder(child: child)),

        /// The animated background effect

        DartBoardDecoration(
            enabled: !kIsWeb &&
                (Platform.isMacOS || Platform.isLinux || Platform.isWindows),
            name: 'animated_background',
            decoration: (context, child) => AnimatedBackgroundDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  child: child,
                ))
      ];

  @override
  List<DartBoardFeature> get dependencies => [
        ThemeFeature(),
        DebugFeature(),
        LogFeature(),
        MinesweeperFeature(),
        BottomNavTemplateFeature('/main', kMainPageConfig)
      ];

  @override
  List<String> get pageDecorationDenyList => ['/main:animated_background'];

  @override
  List<String> get pageDecorationAllowList =>
      ['/main:color_border', '/main:log_frame'];

  @override
  String get namespace => 'example';
}
