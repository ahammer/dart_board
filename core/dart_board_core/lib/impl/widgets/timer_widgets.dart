import 'dart:async';

import 'package:dart_board_core/dart_board.dart';

/// You can use this to register periodic callbacks in your widget tree
///
class PeriodicWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Function() callback;

  const PeriodicWidget(
      {Key? key,
      required this.child,
      required this.duration,
      required this.callback})
      : super(key: key);

  @override
  _PeriodicState createState() => _PeriodicState();
}

class _PeriodicState extends State<PeriodicWidget> {
  late Timer timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    timer.cancel();
    timer = Timer.periodic(widget.duration, (_) => widget.callback());
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(widget.duration, (_) => widget.callback());
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
