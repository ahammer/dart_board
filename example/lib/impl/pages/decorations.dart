import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final Logger log = Logger('About');

class DecorationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(64.0),
          child: Container(
              width: double.infinity,
              child: FittedBox(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '''Painting your project
At the app and page level
is quick and easy''',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline1!.copyWith(
                          shadows: [
                            BoxShadow(
                                blurRadius: 4,
                                offset: Offset(1, 1),
                                color: Colors.black54)
                          ]),
                    )
                  ],
                ),
              )),
        ),
      );
}
