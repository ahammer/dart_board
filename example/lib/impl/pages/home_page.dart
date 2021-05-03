import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Hero(
              tag: "Title",
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Dart Board",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                ),
                elevation: 4,
              ),
            )),
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
