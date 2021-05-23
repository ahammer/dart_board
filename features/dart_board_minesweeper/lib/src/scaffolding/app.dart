import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:dart_board_minesweeper/src/scaffolding/mine_redux.dart';
import 'package:dart_board_minesweeper/src/state/app_state.dart';
import 'package:dart_board_minesweeper/src/ui/screens/game_screen.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

class MinesweeperApp extends StatelessWidget {
  final store = Store<AppState>(minesweepReducer,
      initialState: AppState.getDefault(), middleware: [thunkMiddleware]);

  @override
  Widget build(BuildContext context) => Provider.value(
      value: store,
      child: StoreProvider(
          store: store,
          child: StoreConnector<AppState, String?>(
              converter: (store) => store.state.theme,
              distinct: true,
              builder: (context, value) => MaterialApp(
                    home: GameScreen(),
                    theme: (value == "Dark")
                        ? ThemeData.dark()
                        : ThemeData.light(),
                  ))));
}
