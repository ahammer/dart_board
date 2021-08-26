import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_template_app_bar_sidenav/dart_board_template_app_bar_sidenav.dart';
import 'package:flutter/material.dart';

/// Minimal Dart Board example.
///
/// Provides a simple page, and a scaffold that would apply to all pages
/// and some basic navigation between 2 routes
///
/// For advanced usages, e.g. App Decorations, Multiple features, AB tests
/// check the example project in the root or at https://dart-board.io
void main() => runApp(DartBoard(
      initialRoute: '/home',
      features: [
        AppBarSideNavTemplateFeature(title: "Example", route: '/home', config: [
          {
            'route': '/first',
            'label': 'First',
            'color': Colors.blue,
            'icon': Icons.car_rental
          },
          {
            'route': '/second',
            'label': 'Second',
            'color': Colors.red,
            'icon': Icons.ac_unit
          }
        ]),
        SimpleRouteFeature()
      ],
    ));

class SimpleRouteFeature extends DartBoardFeature {
  @override
  String get namespace => 'main_page';

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: '/first',
            builder: (ctx, settings) => Container(
                  width: double.infinity,
                  child: Card(child: Text('Home Page')),
                )),
        NamedRouteDefinition(
            route: '/second',
            builder: (ctx, settings) => Container(
                  width: double.infinity,
                  child: Card(child: Text('Second Page')),
                )),
      ];
}
