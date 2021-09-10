import 'package:dart_board_core/dart_board.dart';
import 'state/bottom_nav_state.dart';
import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final log = Logger('BottomNavTemplateFeature');

/// This Feature provides a Template/Starting point
/// for a Dart Board UI
///
/// Config is a map
/// {'/route': {'title': 'Icon Title', 'color': Colors.blue, 'icon', Icons.ac_unit}}
///
/// It will be validated at startup. Keep an eye for errors in your logs
/// The types are important. (String, Color, IconData).
///
/// You can add as many /routes as you want to the config.
///
/// if you don't get an exception, your config should be safe
///
class BottomNavTemplateFeature extends DartBoardFeature {
  final String route;
  final List<Map<String, dynamic>> Function(BuildContext) config;
  final bool decorateRoutes;

  ///Expose namespace/implementation name so we can AB test layouts easily
  final String namespace;
  final String implementationName;

  BottomNavTemplateFeature(
      {required this.route,
      required this.config,
      this.decorateRoutes = true,
      this.namespace = 'bottom_nav_template_feature',
      this.implementationName = 'Bottom Navigation'});

  @override
  List<DartBoardDecoration> get appDecorations => [
        DartBoardDecoration(
            name: 'bottom_nav_state',
            decoration: (ctx, child) =>
                ChangeNotifierProvider<BottomNavTemplateState>(
                    key: Key('bottom_nav_state'),
                    create: (ctx) {
                      validateConfig(ctx);
                      return BottomNavTemplateState(config(ctx));
                    },
                    child: child))
      ];

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: route, builder: (ctx, settings) => BottomNavTemplate())
      ];

  /// This is a runtime safety check to ensure that the config looks valid
  /// Additional checks can be added here (e.g. regex, length checks, etc)
  void validateConfig(BuildContext context) =>
      config(context).forEach((element) {
        if (!(element["route"] is String)) {
          throw Exception("route must be a String");
        }
        if (!(element["label"] is String)) {
          throw Exception("label must be a String");
        }
        if (!(element["color"] is Color)) {
          throw Exception("color must be a Color");
        }
        if (!(element["icon"] is IconData)) {
          throw Exception("icon must be IconData");
        }
        if (!(element["decorate"] is bool) && element["decorate"] != null) {
          throw Exception("icon must be IconData");
        }
      });
}

class BottomNavTemplate extends StatelessWidget {
  const BottomNavTemplate();

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavTemplateState>(
      builder: (ctx, navstate, child) {
        final active = navstate.config.where(
            (e) => DartBoardCore.instance.confirmRouteExists(e["route"]));

        return Scaffold(
          body: AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            child: RouteWidget(
              navstate.selectedRoute,
              decorate: navstate.selectedConfig["decorate"] ?? true,
              key: Key(navstate.selectedRoute),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            elevation: 1,
            type: BottomNavigationBarType.shifting,
            items: <BottomNavigationBarItem>[
              ...active
                  .map((e) => BottomNavigationBarItem(
                      icon: Icon(e['icon']),
                      label: e['label'],
                      backgroundColor: e['color']))
                  .toList(),
            ],
            currentIndex: navstate.selectedTab,
            selectedItemColor: Theme.of(context).colorScheme.surface,
            unselectedItemColor:
                Theme.of(context).colorScheme.surface.withOpacity(0.8),
            onTap: (value) {
              navstate.selectedTabIndex = value;
              navstate.selectedRoute = active.toList()[value]["route"];
            },
          ),
        );
      },
    );
  }
}
