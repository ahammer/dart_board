import 'package:dart_board_theme_extension/theme_extension.dart';
import 'package:example/impl/dart_board_nav_drawer.dart';
import 'package:flutter/material.dart';

class ScaffoldWithDrawerDecoration extends StatelessWidget {
  final Widget child;
  const ScaffoldWithDrawerDecoration({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      drawer: ExampleNavDrawer(),
      appBar: AppBar(
        title: Text('Example App'),
        actions: [
          IconButton(
              icon: Icon(Icons.lightbulb),
              onPressed: () => ThemeExtension.toggle(context))
        ],
      ),
      body: child);
}
