import 'package:dart_board/dart_board.dart';
import 'package:flutter/material.dart';

class AppState {
  int selectedNavTab = 0;
}

extension AppStateContextExtension on BuildContext {
  AppState get appState => Provider.of<AppState>(this, listen: false);
}
