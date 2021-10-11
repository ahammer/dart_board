import 'package:flutter/material.dart';

/// Boolean Builder
///
/// If Value == True, build onTrue
/// If Value == False, build onFalse
class BooleanBuilder extends StatelessWidget {
  final bool value;
  final WidgetBuilder onTrue;
  final WidgetBuilder onFalse;

  const BooleanBuilder({
    Key? key,
    required this.value,
    required this.onTrue,
    required this.onFalse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      value ? onTrue(context) : onFalse(context);
}
