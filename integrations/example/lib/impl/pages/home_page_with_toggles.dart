import 'package:flutter/material.dart';

class HomePageWithToggles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page with Toggles')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 800) {
            // Desktop layout
            return Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Sidebar(), // Sidebar for navigation and controls
                ),
                Expanded(
                  flex: 3,
                  child: ContentArea(), // Main content area
                ),
              ],
            );
          } else {
            // Mobile layout
            return ContentArea(); // Main content area with bottom navigation
          }
        },
      ),
      bottomNavigationBar: constraints.maxWidth < 800 ? BottomNavBar() : null,
    );
  }
}

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Text('Menu')),
          ListTile(
            title: Text('Home'),
            onTap: () {},
          ),
          // Add more navigation items here
        ],
      ),
    );
  }
}

class ContentArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Main Content Area'),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        // Add more navigation items here
      ],
    );
  }
}
