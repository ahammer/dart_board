import 'package:dart_board_canvas/dart_board_canvas.dart';
import 'package:dart_board_firebase_analytics/dart_board_firebase_analytics.dart';
import 'package:dart_board_firebase_authentication/dart_board_firebase_authentication.dart';
import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_core/impl/features/generic_features.dart';
import 'package:dart_board_chat/dart_board_chat.dart';
import 'package:dart_board_minesweeper/dart_board_minesweeper.dart';
import 'package:dart_board_particles/dart_board_particle_feature.dart';
import 'package:dart_board_particles/features/cursor_particle_features.dart';
import 'package:dart_board_particles/features/snow_feature.dart';
import 'package:dart_board_space_scene/space_scene_feature.dart';
import 'package:dart_board_splash/dart_board_splash.dart';
import 'package:dart_board_template_app_bar_sidenav/dart_board_template_app_bar_sidenav.dart';
import 'package:dart_board_theme/dart_board_theme.dart';
import 'package:dart_board_debug/debug_feature.dart';
import 'package:dart_board_log/dart_board_log.dart';
import 'package:example/impl/pages/home_page_with_toggles.dart';
import 'package:example/impl/splash/splash.dart';
import 'data/constants.dart';
import 'impl/decorations/wavy_lines_background.dart';
import 'package:dart_board_template_bottomnav/dart_board_template_bottomnav.dart';
import 'package:dart_board_image_background/dart_board_image_background.dart';
import 'package:flutter/material.dart';

/// The Example Feature
///
/// A feature is a set of capabilities you would like to add to an app.
/// For this example, we re going to provide a few things.
///
/// 1) Routes
/// 2) Page Decorations and Config
/// 3) Feature Dependencies
class ExampleFeature extends DartBoardFeature {
  /// A namespace for the feature.
  /// Should be unique to the feature.
  ///
  /// Can conflict, if the expectation is AB test with another feature
  /// Only 1 will load.
  @override
  String get namespace => 'example';

  /// These are the features the Example Uses
  ///
  /// If you remember, our main.dart only brought ExampleExtension
  /// This extension is an "integration" extension,
  /// it's goal is to glue everything else together.
  ///
  ///
  @override
  List<DartBoardFeature> get dependencies => [
        DartBoardCanvasFeature(
            stateBuilder: () => SplashAnimation(),
            namespace: 'splash_background',
            implementationName: 'static',
            route: '/splash_bg',
            showFpsOverlay: false),

        /// Splash Screen, we'll for now, just use some Text
        DartBoardSplashFeature(
          FadeOutSplashScreen(
            delay: Duration(milliseconds: 1500),

            /// We will use our own fade (I want to tween out the image filter)
            fadeDuration: Duration(milliseconds: 2500),
            contentBuilder: (context) => ExampleSplashWidget(),
          ),
        ),
        ThemeFeature(data: ThemeData.light()),
        DebugFeature(),
        LogFeature(),
        MinesweeperFeature(),
        FireCursorFeature(),
        RainbowCursorFeature(),
        DartBoardAuthenticationFlutterFireFeature(),
        DartBoardChatFeature(),
        DartBoardFirebaseAnalytics(),

        /// Add 2 template's
        /// can toggle in debug
        BasicRouteFeature(
            namespace: 'homepage',
            targetRoute: '/homepage',
            builder: (ctx) => HomePageWithToggles()),

        BottomNavTemplateFeature(
            implementationName: 'bottomNav',
            route: '/main',
            config: kMainPageConfig,
            namespace: 'template'),

        AppBarSideNavTemplateFeature(
            route: '/main',
            implementationName: 'sideNav',
            config: kMainPageConfig,
            title: 'Example App',
            namespace: 'template'),

        /// We register the clocks as 3 features, since it's bound to the image_background
        /// Another approach is to have the image background -> route, and then select the space variant
        /// But I did it this way because I want them all on the "background" feature
        SpaceSceneFeature(
          namespace: 'clock',
          implementationName: 'Space Clock - Stars',
          route: '/space',
          showEarth: false,
          showMoon: false,
          showSun: false,
        ),

        SpaceSceneFeature(
          namespace: 'clock2',
          route: '/space_earth',
          implementationName: 'Space Clock - Earth',
          showEarth: true,
          showMoon: false,
          showSun: false,
        ),

        SpaceSceneFeature(
          namespace: 'clock3',
          route: '/space_all',
          implementationName: 'Space Clock - All',
          showEarth: true,
          showMoon: true,
          showSun: true,
        ),

        /// Here we register the actual backgrounds we can use
        /// There is a variety of features to provide a background
        /// they are all on the namespace "background"
        ///
        /// They all generally apply a page decoration with a stack
        /// to place the content on
        ImageBackgroundFeature(
            widget: Container(
                width: double.infinity,
                height: double.infinity,
                child: RouteWidget('/space_earth')),
            namespace: 'background',
            implementationName: 'ClockEarth'),

        /// We are going to mount the SpaceClock using the ImageBackgroundFeature widget option
        ImageBackgroundFeature(
            widget: Container(
                width: double.infinity,
                height: double.infinity,
                child: RouteWidget('/space')),
            namespace: 'background',
            implementationName: 'ClockStars'),

        /// We are going to mount the SpaceClock using the ImageBackgroundFeature widget option
        ImageBackgroundFeature(
            widget: Container(
                width: double.infinity,
                height: double.infinity,
                child: RouteWidget('/space_all')),
            namespace: 'background',
            implementationName: 'ClockAll'),

        ImageBackgroundFeature(
            filename: 'assets/sunset_painting.jpg',
            namespace: 'background',
            implementationName: 'City Image'),

        AnimatedBackgroundFeature(),

        ImageBackgroundFeature(
            filename: 'assets/mush.jpg',
            namespace: 'background',
            implementationName: 'Mushroom Image'),

        /// Isolate the frame into a feature so it can be disabled
        //particleFeature,
        SnowFeature(),
      ];

  bool _init = false;
  final particleFeature = DartBoardParticleFeature();
  //..addLayer(LightingParticleLayer());
  @override
  List<DartBoardDecoration> get appDecorations => <DartBoardDecoration>[
        DartBoardDecoration(
            name: 'Example Initializer',
            enabled: false,
            decoration: (ctx, child) => LifeCycleWidget(
                  key: ValueKey('Example Initializer'),
                  init: (ctx) {
                    if (_init) return;

                    <String>[
                      'theme',
                      'FireCursor',
                      'Snow',
                      //'Snow'
                    ].forEach((element) => DartBoardCore.instance
                        .setFeatureImplementation(element, null));

                    DartBoardCore.instance
                        .setFeatureImplementation('Background', 'image');

                    _init = true;
                  },
                  child: child,
                ))
      ];

  @override
  List<String> get pageDecorationDenyList => ['/main:animated_background'];

  @override
  List<String> get pageDecorationAllowList => [
        '/main:color_border',
        '/main:log_frame',
      ];
}
