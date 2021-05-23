import 'package:dart_board/dart_board.dart';
import 'package:dart_board_theme/theme_feature.dart';
import 'package:flutter/material.dart';
import '../state/nav_state.dart';

final routes = [
  '/home',
  '/about',
  '/decorations',
  '/routing',
  '/features',
  '/debug',
  '/minesweep'
];

class MainPage extends StatelessWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<NavState>(
        builder: (ctx, navstate, child) => Scaffold(
          floatingActionButton: FloatingActionButton(
            mini: true,
            onPressed: () => ThemeFeature.toggle(context),
            child: Icon(Icons.lightbulb),
          ),
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
