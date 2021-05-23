import 'package:dart_board/dart_board.dart';

import 'src/scaffolding/app.dart';

/// This is a very simple integration
///
/// Demonstrating one app right into another
class MinesweeperFeature extends DartBoardFeature {
  @override
  String get namespace => "MineSweeper";

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: "/minesweep", builder: (ctx, settings) => MinesweeperApp())
      ];
}
