import 'dart:async';

import 'package:dart_board_core/dart_board.dart';

// This widget can tap into life cycle
//
class LifeCycleWidget extends StatefulWidget {
  final Widget child;
  final Function(BuildContext context)? init;
  final Function(BuildContext context)? dispose;

  const LifeCycleWidget(
      {Key? key, required this.child, required this.init, this.dispose})
      : super(key: key);

  @override
  _LifeCycleWidgetState createState() => _LifeCycleWidgetState();
}

class _LifeCycleWidgetState extends State<LifeCycleWidget> {
  @override
  void initState() {
    Timer.run(() => widget.init?.call(context));
    super.initState();
  }

  @override
  void dispose() {
    widget.dispose?.call(context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
