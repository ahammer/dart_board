import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_minesweeper/src/state/app_state.dart';
import 'package:dart_board_redux/dart_board_redux.dart';
import 'src/ui/screens/game_screen.dart';

/// This is a very simple integration
///
/// Demonstrating one app right into another
class MinesweeperFeature extends DartBoardFeature {
  @override
  String get namespace => "MineSweeper";

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: "/minesweep", builder: (ctx, settings) => GameScreen())
      ];

  @override
  List<DartBoardDecoration> get appDecorations => [
        ReduxStateDecoration<MinesweeperState>(
            factory: () => MinesweeperState.getDefault(),
            name: "minesweeper_state"),
      ];

  @override
  List<DartBoardFeature> get dependencies => [DartBoardRedux()];
}
