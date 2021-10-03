import 'package:dart_board_minesweeper/dart_board_minesweeper.dart';
import 'package:dart_board_spacex_ui/spacex_ui_feature.dart';
import 'package:flutter/material.dart';
import 'package:dart_board_core/dart_board.dart';

void main() {
  runApp(DartBoard(
    features: [MinesweeperFeature(), SpaceXUIFeature()],
    initialRoute: '/minesweep',
  ));
}
