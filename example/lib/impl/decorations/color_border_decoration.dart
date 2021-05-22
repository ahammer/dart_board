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
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(16), child: child),
          ),
        ),
      );
}
