import 'package:dart_board_minesweeper/src/state/app_state.dart';

MinesweeperState minesweepReducer(MinesweeperState oldState, dynamic action) {
  if (action is Reducer) {
    return action.reducer(oldState);
  }
  return oldState;
}

abstract class Reducer {
  MinesweeperState Function(MinesweeperState oldState) get reducer;
}
