import 'dart:async';

import 'package:flutter/material.dart';

/// You can use this to register periodic callbacks in your widget tree
///
class PeriodicWidget extends StatefulWidget {
  final Widget child;
  final Widget Function(BuildContext context, Widget child, int interval)?
      builder;
  final Duration duration;
  final Function(int interval) callback;

  const PeriodicWidget(
      {Key? key,
      required this.child,
      required this.duration,
      required this.callback,
      this.builder})
      : super(key: key);

  @override
  _PeriodicState createState() => _PeriodicState();
}

class _PeriodicState extends State<PeriodicWidget> {
  late Timer timer;
  var interval = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    timer.cancel();
    timer = Timer.periodic(widget.duration, (_) {
      if (widget.builder != null) setState(() {});
      interval++;
      return widget.callback(interval);
    });
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(widget.duration, (_) {
      if (widget.builder != null) setState(() {});
      interval++;
      return widget.callback(interval);
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder?.call(context, widget.child, interval) ?? widget.child;
}
