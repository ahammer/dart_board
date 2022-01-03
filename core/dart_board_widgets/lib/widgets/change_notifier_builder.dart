import 'dart:async';

import 'package:flutter/material.dart';

/// ChangeNotifierBuilder Extension
///
/// Have you ever wanted to go
///
/// someChangeNotifier.builder((ctx, val)=>build);
///
/// That's what this is for, so you can convert ChangeNotifiers into widgets
///
/// Since this is on ChangeNotifier, you'll need to specify your type again
extension ChangeNotifierBuilderExtension on ChangeNotifier {
  Widget builder<T extends ChangeNotifier>(
          Widget Function(BuildContext context, T value) handler) =>
      ChangeNotifierBuilder<T>(notifier: this as T, builder: handler);
}

/// Takes a ChangeNotifier and Builds with It
class ChangeNotifierBuilder<T extends ChangeNotifier> extends StatefulWidget {
  final Widget Function(BuildContext context, T value) builder;
  final T notifier;

  const ChangeNotifierBuilder(
      {Key? key, required this.builder, required this.notifier})
      : super(key: key);

  @override
  _ChangeNotifierBuilderState createState() => _ChangeNotifierBuilderState<T>();
}

class _ChangeNotifierBuilderState<T extends ChangeNotifier>
    extends State<ChangeNotifierBuilder<T>> {
  void onUpdate() => Timer.run(() => setState(() {}));

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  @override
  void initState() {
    widget.notifier.addListener(onUpdate);
    super.initState();
  }

  @override
  void dispose() {
    widget.notifier.removeListener(onUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, widget.notifier);
}

/// Takes two ChangeNotifier and Builds with them with a function
/// Syntactic sugar
class ChangeNotifierBuilder2<T extends ChangeNotifier, V extends ChangeNotifier>
    extends StatefulWidget {
  final Widget Function(BuildContext context, T value1, V value2) builder;
  final T notifier1;
  final V notifier2;

  const ChangeNotifierBuilder2({
    Key? key,
    required this.builder,
    required this.notifier1,
    required this.notifier2,
  }) : super(key: key);

  @override
  _ChangeNotifierBuilderState2 createState() =>
      _ChangeNotifierBuilderState2<T, V>();
}

class _ChangeNotifierBuilderState2<T extends ChangeNotifier,
    V extends ChangeNotifier> extends State<ChangeNotifierBuilder2<T, V>> {
  void onUpdate() => Timer.run(() => setState(() {}));

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  @override
  void initState() {
    widget.notifier1.addListener(onUpdate);
    widget.notifier2.addListener(onUpdate);
    super.initState();
  }

  @override
  void dispose() {
    widget.notifier1.removeListener(onUpdate);
    widget.notifier2.removeListener(onUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, widget.notifier1, widget.notifier2);
}

/// Takes two ChangeNotifier and Builds with them with a function
/// Syntactic sugar
class ChangeNotifierBuilder3<T extends ChangeNotifier, V extends ChangeNotifier,
    Z extends ChangeNotifier> extends StatefulWidget {
  final Widget Function(BuildContext context, T value1, V value2, Z notifier3)
      builder;
  final T notifier1;
  final V notifier2;
  final Z notifier3;

  const ChangeNotifierBuilder3(
      {Key? key,
      required this.builder,
      required this.notifier1,
      required this.notifier2,
      required this.notifier3})
      : super(key: key);

  @override
  _ChangeNotifierBuilderState3 createState() =>
      _ChangeNotifierBuilderState3<T, V, Z>();
}

/// Same as above, but for 3
class _ChangeNotifierBuilderState3<
    T extends ChangeNotifier,
    V extends ChangeNotifier,
    Z extends ChangeNotifier> extends State<ChangeNotifierBuilder3<T, V, Z>> {
  void onUpdate() => Timer.run(() => setState(() {}));

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  @override
  void initState() {
    widget.notifier1.addListener(onUpdate);
    widget.notifier2.addListener(onUpdate);
    widget.notifier3.addListener(onUpdate);
    super.initState();
  }

  @override
  void dispose() {
    widget.notifier1.removeListener(onUpdate);
    widget.notifier2.removeListener(onUpdate);
    widget.notifier3.removeListener(onUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(
      context, widget.notifier1, widget.notifier2, widget.notifier3);
}
