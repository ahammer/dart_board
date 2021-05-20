import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

final Logger log = Logger('About');

class AboutPage extends StatelessWidget {
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
                      '''Need to integrate?
Dart board will do that for you
It will be simple''',
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
