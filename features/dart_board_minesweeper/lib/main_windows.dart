import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dart_board_minesweeper/src/scaffolding/app.dart';

//Start the app through the main entry point
void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(MinesweeperApp());
}
