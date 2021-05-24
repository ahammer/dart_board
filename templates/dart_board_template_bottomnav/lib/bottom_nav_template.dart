import 'package:dart_board/dart_board.dart';

import 'state/nav_state.dart';

final routes = [
  '/home',
  '/about',
  '/decorations',
  '/routing',
  '/features',
  '/debug',
  '/minesweep'
];

/// This Feature provides a Template/Starting point
/// for a Dart Board UI
class BottomNavTemplateFeature extends DartBoardFeature {
  final String route_name;

  @override
  String get namespace => "BottomNavTemplate";

  BottomNavTemplateFeature(this.route_name);

  @override
  List<WidgetWithChildBuilder> get appDecorations => [
        (ctx, child) => ChangeNotifierProvider<NavState>(
            create: (ctx) => NavState(), child: child)
      ];

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: route_name, builder: (ctx, settings) => BottomNavTemplate())
      ];
}

class BottomNavTemplate extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<NavState>(
        builder: (ctx, navstate, child) => Scaffold(
          body: AnimatedSwitcher(
            duration: Duration(seconds: 1),
            child: RouteWidget(
              decorate: true,
              key: Key('tab_${navstate.selectedNavTab}'),
              settings: RouteSettings(name: routes[navstate.selectedNavTab]),
            ),
          ),
          bottomNavigationBar: Hero(
            tag: 'EXAMPLE_BOTTOM_TOOLBAR',
            child: BottomNavigationBar(
              elevation: 3,
              type: BottomNavigationBarType.shifting,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                    backgroundColor: Colors.red),
                BottomNavigationBarItem(
                  icon: Icon(Icons.call_merge),
                  label: 'Integrate',
                  backgroundColor: Colors.green,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.brush),
                  label: 'Decorations',
                  backgroundColor: Colors.orange,
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.navigation),
                    label: 'Routing',
                    backgroundColor: Colors.cyan),
                BottomNavigationBarItem(
                    icon: Icon(Icons.ac_unit),
                    label: 'Features',
                    backgroundColor: Colors.amber),
                BottomNavigationBarItem(
                    icon: Icon(Icons.plumbing),
                    label: 'Debug',
                    backgroundColor: Colors.amber),
                BottomNavigationBarItem(
                    icon: Icon(Icons.gamepad_outlined),
                    label: 'Minesweep',
                    backgroundColor: Colors.amber),
              ],
              currentIndex: navstate.selectedNavTab,
              selectedItemColor: Theme.of(context).colorScheme.surface,
              unselectedItemColor:
                  Theme.of(context).colorScheme.surface.withOpacity(0.8),
              onTap: (value) {
                navstate.selectedNavTab = value;
              },
            ),
          ),
        ),
      );
}
