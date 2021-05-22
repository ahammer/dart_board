import 'package:dart_board/dart_board.dart';
import 'package:flutter/material.dart';
import '../state/nav_state.dart';

final routes = ['/home', '/about', '/decorations', '/routing', '/features'];

class MainPage extends StatelessWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Consumer<NavState>(
        builder: (ctx, navstate, child) => Scaffold(
          body: AnimatedSwitcher(
            duration: Duration(seconds: 1),
            child: RouteWidget(
              decorate: false,
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
                  icon: Icon(Icons.info),
                  label: 'About',
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
                    icon: Icon(Icons.plumbing),
                    label: 'Features',
                    backgroundColor: Colors.amber),
              ],
              currentIndex: navstate.selectedNavTab,
              selectedItemColor: Colors.black,
              onTap: (value) {
                navstate.selectedNavTab = value;
              },
            ),
          ),
        ),
      );
}
