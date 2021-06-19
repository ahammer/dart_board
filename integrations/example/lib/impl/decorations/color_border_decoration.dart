import 'package:flutter/material.dart';

class DarkColorBorder extends StatelessWidget {
  final Widget child;
  const DarkColorBorder({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        color: Theme.of(context).colorScheme.background,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: SafeArea(child: child)),
        ),
      );
}
