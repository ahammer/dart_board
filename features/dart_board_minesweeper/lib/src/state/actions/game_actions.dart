import 'package:dart_board_minesweeper/src/state/app_state.dart';
import 'package:dart_board_redux/dart_board_redux.dart';

class SetDifficultyAction extends FeatureAction<MinesweeperState> {
  final String? difficulty;
  SetDifficultyAction(this.difficulty);

  get reducer =>
      (oldState) => oldState.rebuild((b) => b..difficulty = difficulty);

  @override
  MinesweeperState featureReduce(MinesweeperState state) => reducer(state);
}
