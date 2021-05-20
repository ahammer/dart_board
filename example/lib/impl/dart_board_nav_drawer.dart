import 'package:flutter/material.dart';

/// Dart Board Nav Drawer
///
/// A very basic nav drawer for routes.
class ExampleNavDrawer extends StatelessWidget {
  const ExampleNavDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
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
                      'Routes',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ),
              ),
            ),
            ...['/home', '/about', '/features', '/debug'].map(
              (e) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('$e');
                  },
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      '$e',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
