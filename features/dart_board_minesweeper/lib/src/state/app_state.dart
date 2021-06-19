import 'package:built_value/built_value.dart';

import 'mine_sweeper.dart';

part 'app_state.g.dart';

//This will represent the App State
abstract class MinesweeperState
    implements Built<MinesweeperState, MinesweeperStateBuilder> {
  MinesweeperState._();
  factory MinesweeperState([void Function(MinesweeperStateBuilder)? updates]) =
      _$MinesweeperState;

  //Get the default, no-args App State
  factory MinesweeperState.getDefault() => MinesweeperState((b) => b
    ..mineSweeper.replace(MineSweeper.newGame())
    ..difficulty = "Easy");

  //The current difficulty ("Easy, Medium, Hard")
  String get difficulty;

  //The current game board
  MineSweeper get mineSweeper;
}
