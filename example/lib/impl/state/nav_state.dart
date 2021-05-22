import 'package:flutter/material.dart';

/// This is a simple state object
///
/// It tracks the active tab at the app level
class NavState extends ChangeNotifier {
  int _selectedNavTab = 0;

  int get selectedNavTab => _selectedNavTab;
  set selectedNavTab(int idx) {
    _selectedNavTab = idx;
    notifyListeners();
  }
}
