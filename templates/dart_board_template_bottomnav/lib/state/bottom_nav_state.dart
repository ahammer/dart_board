import 'package:flutter/material.dart';

/// This is a simple state object
///
/// It tracks the active tab at the app level
class BottomNavTemplateState extends ChangeNotifier {
  /// We take the Config into the State so we can access it easily
  final List<Map<String, dynamic>> config;

  int _selectedNavTab = 0;

  BottomNavTemplateState(this.config);

  int get selectedNavTab => _selectedNavTab;
  set selectedNavTab(int idx) {
    _selectedNavTab = idx;
    notifyListeners();
  }
}
