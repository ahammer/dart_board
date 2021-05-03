import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Hero(
                tag: "Title",
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "About",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                  elevation: 4,
                ),
              ),
            ),
            Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Modular Flutter App Framework",
                style: Theme.of(context).textTheme.headline4,
              ),
            ))
          ],
        ),
      );
}
