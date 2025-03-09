import 'package:dart_board_core_plugin/dart_board_core_plugin.dart';
import 'package:dart_board_minesweeper/dart_board_minesweeper.dart';
import 'package:flutter/material.dart';
import 'package:dart_board_core/dart_board_core.dart';

void main() {
  runApp(DartBoard(
    features: [
      MinesweeperFeature(),
      Add2AppFeature(),
    ],
    initialPath: '/minesweep',
  ));
}
