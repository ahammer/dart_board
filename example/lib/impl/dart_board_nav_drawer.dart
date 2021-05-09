import 'package:dart_board_interface/dart_board_core.dart';
import 'package:flutter/material.dart';

/// Dart Board Nav Drawer
///
/// A very basic nav drawer for routes.
///
/// TODO: Add a whitelist, and a route->name map
/// TODO: Add a "current route" screen
class DartBoardNavDrawer extends StatelessWidget {
  const DartBoardNavDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 4,
                child: Center(
                  child: Text(
                    "Routes",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ),
            ),
          ),
          ...DartBoardCore.getRoutes().map(
            (e) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "$e",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed("$e");
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
