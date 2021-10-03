import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_minesweeper/dart_board_minesweeper.dart';
import 'package:flutter/material.dart';

/// Simple minesweep runner
void main() => runApp(
    DartBoard(initialPath: '/minesweep', features: [MinesweeperFeature()]));
