import 'package:built_value/built_value.dart';

import 'mine_sweeper.dart';

part 'app_state.g.dart';

//This will represent the App State
abstract class AppState implements Built<AppState, AppStateBuilder> {
  AppState._();
  factory AppState([void Function(AppStateBuilder)? updates]) = _$AppState;

  //Get the default, no-args App State
  factory AppState.getDefault() => AppState((b) => b
    ..theme = "Light"
    ..difficulty = "Easy");

  //The current theme ("Light" or "Dark")
  String? get theme;

  //The current difficulty ("Easy, Medium, Hard")
  String? get difficulty;

  //The current game board
  MineSweeper? get mineSweeper;
}
