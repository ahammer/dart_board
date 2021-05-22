import 'package:flutter/material.dart';
import '../state/app_state.dart';

class ScaffoldWithDrawerDecoration extends StatelessWidget {
  final Widget child;
  const ScaffoldWithDrawerDecoration({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: child,
        bottomNavigationBar: Hero(
          tag: 'EXAMPLE_BOTTOM_TOOLBAR',
          child: BottomNavigationBar(
            elevation: 3,
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.info),
                label: 'About',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.art_track),
                label: 'Decorations',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.school),
                label: 'Routing',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.school),
                label: 'Features',
              ),
            ],
            currentIndex: context.appState.selectedNavTab,
            selectedItemColor: Colors.amber[800],
            onTap: (value) {
              context.appState.selectedNavTab = value;

              Navigator.of(context).pushNamed([
                '/home',
                '/about',
                '/decorations',
                '/routing',
                '/features'
              ][value]);
            },
          ),
        ),
      );
}
