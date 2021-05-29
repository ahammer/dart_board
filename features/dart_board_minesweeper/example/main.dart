import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_minesweeper/minesweeper_feature.dart';
import 'package:flutter/cupertino.dart';

/// Simple minesweep runner
void main() => runApp(
    DartBoard(initialRoute: '/minesweep', features: [MinesweeperFeature()]));
