import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// This is a simple state object
///
/// It tracks the active tab at the app level
class BottomNavTemplateState extends ChangeNotifier {
  /// We take the Config into the State so we can access it easily
  final List<Map<String, dynamic>> config;

  String? _selectedRoute;
  int? _selectedTab;

  BottomNavTemplateState(this.config) : _selectedRoute = config[0]["route"];

  String get selectedRoute => _selectedRoute ?? "404";

  int get selectedTab => _selectedTab ?? 0;

  Map<String, dynamic> get selectedConfig =>
      config.where((e) => e["route"] == selectedRoute).first;

  set selectedRoute(String route) {
    _selectedRoute = route;
    _selectedTab = config.indexOf(selectedConfig);
    notifyListeners();
  }

  set selectedTabIndex(int index) {
    _selectedTab = index;
    notifyListeners();
  }
}

/// Messenger for the state object
class BottomNavMessenger {
  static void requestNewRoute(BuildContext context, String route) =>
      Provider.of<BottomNavTemplateState>(context, listen: false)
          .selectedRoute = route;
}
