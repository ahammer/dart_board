import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_core/interface/dart_board_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/navigator.dart';

/// The idea of this resolver is to not only do a name but also a tree
/// You can specify routes in a table, and it can validate each path segment
///
class PathedRouteDefinition extends RouteDefinition {
  /// data format is
  /// level, namedroute
  ///
  /// Hard coding for development
  final routes = <List<NamedRouteDefinition>>[
    /// Level 0
    [
      NamedRouteDefinition(
          route: 'root',
          builder: (ctx, settings) => Scaffold(body: Text('Root')))
    ],

    /// Level 1 (e.g. /root/cata)
    [
      NamedRouteDefinition(
          route: 'cata', builder: (ctx, settings) => Scaffold(body: Text('A'))),
      NamedRouteDefinition(
          route: 'catb', builder: (ctx, settings) => Scaffold(body: Text('B')))
    ],

    /// Level 2
    [
      NamedRouteDefinition(
          route: 'details',
          builder: (ctx, settings) => Scaffold(body: Text('Details')))
    ],
  ];

  @override
  RouteWidgetBuilder get builder => routes[1][0].builder;

  @override
  bool matches(RouteSettings settings) {
    final url = Uri.tryParse(settings.name!);
    if (url == null) return false;

    print(url.pathSegments.length);
    for (var i = 0; i < url.pathSegments.length; i++) {
      print(url.pathSegments[i]);
    }
    return true;
  }
}
