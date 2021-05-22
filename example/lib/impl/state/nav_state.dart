import 'package:flutter/material.dart';

class NavState extends ChangeNotifier {
  int _selectedNavTab = 0;

  int get selectedNavTab => _selectedNavTab;
  set selectedNavTab(int idx) {
    _selectedNavTab = idx;
    notifyListeners();
  }
}
