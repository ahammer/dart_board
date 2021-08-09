import 'package:flutter/material.dart';

/// This is a simple state object
///
/// It tracks the active tab at the app level
class AppBarNavTemplateState extends ChangeNotifier {
  /// We take the Config into the State so we can access it easily
  final List<Map<String, dynamic>> config;

  String _selectedNavTab;

  AppBarNavTemplateState(this.config, this._selectedNavTab);

  String get selectedNavTab => _selectedNavTab;
  set selectedNavTab(String route) {
    _selectedNavTab = route;
    notifyListeners();
  }
}
