import 'package:dart_board_minesweeper/src/scaffolding/mine_redux.dart';

class SetThemeAction extends Reducer {
  final String? theme;
  SetThemeAction(this.theme);

  @override
  get reducer => (oldState) => oldState.rebuild((b) => b..theme = theme);
}

class SetDifficultyAction extends Reducer {
  final String? difficulty;
  SetDifficultyAction(this.difficulty);

  @override
  get reducer =>
      (oldState) => oldState.rebuild((b) => b..difficulty = difficulty);
}
