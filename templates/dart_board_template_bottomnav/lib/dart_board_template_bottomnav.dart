import 'package:dart_board_core/dart_board.dart';
import 'state/bottom_nav_state.dart';
import 'package:logging/logging.dart';

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
  final List<Map<String, dynamic>> config;

  ///Expose namespace/implementation name so we can AB test layouts easily
  final String namespace;
  final String implementationName;

  BottomNavTemplateFeature(
      {required this.route,
      required this.config,
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
                      validateConfig();
                      return BottomNavTemplateState(config);
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
  void validateConfig() => config.forEach((element) {
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
      });
}

class BottomNavTemplate extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<BottomNavTemplateState>(
        builder: (ctx, navstate, child) => Scaffold(
          body: AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            child: RouteWidget(
              decorate: true,
              key: Key('tab_${navstate.selectedNavTab}'),
              settings: RouteSettings(
                  name: navstate.config[navstate.selectedNavTab]['route']),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            elevation: 3,
            type: BottomNavigationBarType.shifting,
            items: <BottomNavigationBarItem>[
              ...navstate.config
                  .map((e) => BottomNavigationBarItem(
                      icon: Icon(e['icon']),
                      label: e['label'],
                      backgroundColor: e['color']))
                  .toList(),
            ],
            currentIndex: navstate.selectedNavTab,
            selectedItemColor: Theme.of(context).colorScheme.surface,
            unselectedItemColor:
                Theme.of(context).colorScheme.surface.withOpacity(0.8),
            onTap: (value) {
              log.info('Changing tab to $value');
              navstate.selectedNavTab = value;
            },
          ),
        ),
      );
}
