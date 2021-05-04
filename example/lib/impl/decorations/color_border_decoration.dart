import 'package:flutter/material.dart';

class DarkColorBorder extends StatelessWidget {
  final Widget child;
  const DarkColorBorder({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        color: Theme.of(context).colorScheme.primaryVariant,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(child: child),
        ),
      );
}
