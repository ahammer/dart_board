import 'package:dart_board_core/dart_board.dart';
import 'state/appbar_nav_state.dart';
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
class AppBarSideNavTemplateFeature extends DartBoardFeature {
  final String route;
  final List<Map<String, dynamic>> config;
  final String title;

  ///Expose namespace/implementation name so we can AB test layouts easily
  final String namespace;
  final String implementationName;

  AppBarSideNavTemplateFeature(
      {required this.route,
      required this.config,
      required this.title,
      this.namespace = 'app_bar_side_nav_template_feature',
      this.implementationName = 'App Bar + Side Nav'});

  @override
  List<DartBoardDecoration> get appDecorations => [
        DartBoardDecoration(
            name: 'bottom_nav_state',
            decoration: (ctx, child) =>
                ChangeNotifierProvider<AppBarNavTemplateState>(
                    key: Key('bottom_nav_state'),
                    create: (ctx) {
                      validateConfig();
                      return AppBarNavTemplateState(config, config[0]['route']);
                    },
                    child: child))
      ];

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: route,
            builder: (ctx, settings) => AppBarSideNavTemplate(title: title))
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
        if (!(element["icon"] is IconData)) {
          throw Exception("icon must be IconData");
        }
      });
}

class AppBarSideNavTemplate extends StatelessWidget {
  final String title;

  const AppBarSideNavTemplate({Key? key, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<AppBarNavTemplateState>(
        builder: (ctx, navstate, child) => Scaffold(
          appBar: AppBar(title: Text(title)),
          body: AnimatedSwitcher(
            duration: Duration(milliseconds: 200),
            child: RouteWidget(
              navstate.selectedNavTab,
              decorate: true,
              key: Key('tab_${navstate.selectedNavTab}'),
            ),
          ),
          drawer: Drawer(
              elevation: 1,
              child: Column(
                  children: navstate.config
                      .where((e) =>
                          DartBoardCore.instance.confirmRouteExists(e['route']))
                      .map((config) => ListTile(
                            leading: Text(config['label']),
                            trailing: Icon(config['icon']),
                            onTap: () {
                              navstate.selectedNavTab = config['route'];
                              Navigator.of(context).pop();
                            },
                          ))
                      .toList())),
        ),
      );
}
