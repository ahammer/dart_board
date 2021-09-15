import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_locator/dart_board_locator.dart';
import 'package:flutter/material.dart';

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
    _selectedTab = config
        .where((element) =>
            DartBoardCore.instance.confirmRouteExists(element["route"]))
        .toList()
        .indexOf(selectedConfig);
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
      locate<BottomNavTemplateState>().selectedRoute = route;
}
