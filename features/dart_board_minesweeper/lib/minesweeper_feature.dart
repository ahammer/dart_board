import 'package:dart_board/dart_board.dart';
import 'package:dart_board_minesweeper/src/state/actions/minesweeper_actions.dart';
import 'package:dart_board_minesweeper/src/state/app_state.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import 'src/scaffolding/mine_redux.dart';
import 'src/ui/screens/game_screen.dart';

/// This is a very simple integration
///
/// Demonstrating one app right into another
class MinesweeperFeature extends DartBoardFeature {
  final store = Store<AppState>(minesweepReducer,
      initialState: AppState.getDefault(), middleware: [thunkMiddleware]);

  @override
  String get namespace => "MineSweeper";

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: "/minesweep",
            builder: (ctx, settings) => StoreConnector<AppState, String?>(
                converter: (store) => store.state.theme,
                distinct: true,
                builder: (context, value) => GameScreen()))
      ];

  @override
  List<DartBoardDecoration> get appDecorations => [
        DartBoardDecoration(
            name: 'minesweeper_redux',
            decoration: (context, child) => Provider.value(
                value: store,
                child: StoreProvider(store: store, child: child))),
        DartBoardDecoration(
            name: 'minesweeper_lifecycle',
            decoration: (context, child) => LifeCycleWidget(
                child: child,
                init: (ctx) {
                  final query = MediaQuery.of(context);
                  store.dispatch(NewGameAction(
                      difficulty: store.state.difficulty,
                      width: query.size.width.toInt(),
                      height: query.size.height.toInt()));
                })),
      ];
}
