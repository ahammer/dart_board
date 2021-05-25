import 'dart:async';

import 'package:dart_board/dart_board.dart';

/// This widget can be used to install hooks into app init quickly
class InitWidget extends StatefulWidget {
  final Widget child;
  final Function(BuildContext context) initHook;

  const InitWidget({Key? key, required this.child, required this.initHook})
      : super(key: key);

  @override
  _InitWidgetState createState() => _InitWidgetState();
}

class _InitWidgetState extends State<InitWidget> {
  @override
  void initState() {
    Timer.run(() => widget.initHook(context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
