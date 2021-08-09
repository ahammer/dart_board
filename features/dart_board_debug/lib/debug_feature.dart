import 'package:dart_board_core/dart_board.dart';

import 'debug_list.dart';

/// This feature is meant to expose the /Debug route,
///
/// It provides some information about the system
/// This is a rough first draft.
class DebugFeature extends DartBoardFeature {
  @override
  List<RouteDefinition> get routes => <RouteDefinition>[
        NamedRouteDefinition(
            route: '/debug', builder: (context, settings) => DebugList())
      ];

  @override
  String get namespace => 'debug';
}
