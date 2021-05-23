import 'package:dart_board/dart_board.dart';
import 'package:dart_board_minesweeper/minesweeper_feature.dart';
import 'package:dart_board_theme/theme_feature.dart';
import 'package:dart_board_debug/debug_feature.dart';
import 'package:dart_board_log/log_feature.dart';
import 'package:example/impl/decorations/wavy_lines_background.dart';
import 'package:example/impl/pages/home_page.dart';
import 'package:example/impl/routes/custom_routes.dart';
import 'impl/decorations/color_border_decoration.dart';
import 'impl/pages/main_page.dart';

import 'impl/pages/haiku_and_code.dart';
import 'impl/state/nav_state.dart';

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
            routeBuilder: kSpinRoute,
            route: '/main',
            builder: (ctx, settings) => MainPage()),
        NamedRouteDefinition(
            route: '/about',
            builder: (ctx, settings) => HaikuAndCode(
                haiku: '''Need to integrate?
Dart board will do that for you
It will be simple''',
                url:
                    'https://raw.githubusercontent.com/ahammer/dart_board/master/example/lib/main.dart')),
        NamedRouteDefinition(
            route: '/decorations',
            builder: (ctx, settings) => HaikuAndCode(
                  haiku: '''Painting your project
At the app and page level
is quick and easy''',
                  url:
                      'https://raw.githubusercontent.com/ahammer/dart_board/master/example/lib/impl/decorations/scaffold_appbar_decoration.dart',
                )),
        NamedRouteDefinition(
            route: '/routing',
            builder: (ctx, settings) => HaikuAndCode(
                  haiku: '''Navigate your app
Features provide named pages
Custom transitions
''',
                  url:
                      'https://raw.githubusercontent.com/ahammer/dart_board/master/example/lib/main.dart',
                )),
        NamedRouteDefinition(
            route: '/features',
            builder: (ctx, settings) => HaikuAndCode(
                  haiku: '''Features are code bits
They hook into your apps quick
Composed, they are strong''',
                  url:
                      'https://raw.githubusercontent.com/ahammer/dart_board/master/example/lib/example_feature.dart',
                ))
      ];

  /// These are page-scoped decorations
  @override
  List<PageDecoration> get pageDecorations => <PageDecoration>[
        PageDecoration(
            name: 'color_border',
            decoration: (context, child) => DarkColorBorder(child: child)),

        /// The animated background effect
        PageDecoration(
            name: 'animated_background',
            decoration: (context, child) => AnimatedBackgroundDecoration(
                  child: child,
                ))
      ];

  @override
  List<WidgetWithChildBuilder> get appDecorations => [
        (ctx, child) => ChangeNotifierProvider<NavState>(
            create: (ctx) => NavState(), child: child)
      ];

  @override
  List<DartBoardFeature> get dependencies =>
      [ThemeFeature(), DebugFeature(), LogFeature(), MinesweeperFeature()];

  /// In the example I block a bunch of page decorations for routes
  ///
  /// Since the Tabs I use in a RouteWidget() I don't want the border/log frame
  /// But I do want the animated background
  ///
  /// However, in MainWidget, I don't want animated background
  /// because it's not visible
  @override
  List<String> get pageDecorationDenyList => [
        '/log:scaffold_and_drawer',
        '/home:color_border',
        '/home:log_frame',
        '/features:color_border',
        '/features:log_frame',
        '/routing:color_border',
        '/routing:log_frame',
        '/decorations:color_border',
        '/decorations:log_frame',
        '/about:color_border',
        '/about:log_frame',
        '/debug:log_frame',
        '/debug:color_border',
        '/main:animated_background',
      ];

  @override
  String get namespace => 'example';
}
