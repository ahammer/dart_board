import 'package:dart_board_redux/dart_board_redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dart_board_minesweeper/src/state/actions/game_actions.dart';
import 'package:dart_board_minesweeper/src/state/actions/minesweeper_actions.dart';
import 'package:dart_board_minesweeper/src/state/app_state.dart';
import 'package:dart_board_minesweeper/src/ui/components/game_board.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          // This is the AppBar Action list
          Container(width: 20),
          Center(child: GameDifficultyWidget()),
          Center(
              child: IconButton(
                  icon: Icon(Icons.play_arrow),
                  onPressed: () => dispatch(NewGameAction(
                        difficulty: getState<MinesweeperState>().difficulty,
                      )))),
          Expanded(child: nil),
          Center(child: Container(child: BombsRemaining())),
          Container(width: 20),
          Center(child: GameTimer()),
          Container(width: 20),
        ],
      ),
      body: GameBoard());
}

class GameDifficultyWidget extends StatelessWidget {
  const GameDifficultyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => FeatureStateBuilder<MinesweeperState>(
      (ctx, value) => DropdownButton<String>(
            value: value.difficulty,
            items: <DropdownMenuItem<String>>[
              ...[
                "Easy",
                "Medium",
                "Hard"
              ].map((s) => DropdownMenuItem<String>(value: s, child: Text(s)))
            ],
            onChanged: (dynamic value) => dispatch(SetDifficultyAction(value)),
          ));
}
