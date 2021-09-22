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
          route: '/root',
          builder: (ctx, settings) => Scaffold(body: Text('Root'))),
      NamedRouteDefinition(
          route: '/Root',
          builder: (ctx, settings) => Scaffold(body: Text('Root')))
    ],

    /// Level 1 (e.g. /root/cata)
    [
      NamedRouteDefinition(
          route: '/cata',
          builder: (ctx, settings) => Scaffold(body: Text('A'))),
      NamedRouteDefinition(
          route: '/catb', builder: (ctx, settings) => Scaffold(body: Text('B')))
    ],

    /// Level 2
    [
      NamedRouteDefinition(
          route: '/details',
          builder: (ctx, settings) => Scaffold(body: Text('Details')))
    ],
  ];

  @override
  RouteWidgetBuilder get builder => (ctx, settings) {
        final url = Uri.tryParse(settings.name!);
        if (url == null) return Text('not found');

        print(url.pathSegments.length);
        RouteDefinition? lastMatching;

        for (var i = 0; i < url.pathSegments.length; i++) {
          var hasMatchAtLevel = false;
          final part = url.pathSegments[i];
          for (final matcher in routes[i]) {
            if (matcher.matches(RouteSettings(name: '/$part'))) {
              lastMatching = matcher;
              hasMatchAtLevel = true;
            }
          }
          if (!hasMatchAtLevel) return Text('No match at level');
        }
        return lastMatching?.builder(ctx, settings) ?? Text('No match found');
      };

  @override
  bool matches(RouteSettings settings) {
    final url = Uri.tryParse(settings.name!);
    if (url == null) return false;

    print(url.pathSegments.length);
    late RouteDefinition? lastMatching;

    for (var i = 0; i < url.pathSegments.length; i++) {
      var hasMatchAtLevel = false;
      final part = url.pathSegments[i];
      for (final matcher in routes[i]) {
        if (matcher.matches(RouteSettings(name: '/$part'))) {
          hasMatchAtLevel = true;
        }
      }
      if (!hasMatchAtLevel) return false;
    }
    return true;
  }
}
