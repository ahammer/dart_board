import 'dart:async';

import 'package:dart_board_core/dart_board.dart';

/// Stubs to link as default functions
dynamic _stub(BuildContext context) {}
dynamic _stub2() {}

// This widget can tap into life cycle
//
// We provide 3 hooks
//
// One at widget startup
// One after widget attached (with context)
// One at onDispose
//
// If you don't need context, use preInit()
//
class LifeCycleWidget extends StatefulWidget {
  final Widget child;

  /// Called in initState() before super.initState()
  final Function() preInit;

  // Called after initState()  (with context)
  final Function(BuildContext context) init;

  // Called in onDispose
  final Function(BuildContext context) dispose;

  const LifeCycleWidget(
      {Key? key,
      required this.child,
      this.init = _stub,
      this.preInit = _stub2,
      this.dispose = _stub})
      : super(key: key);

  @override
  _LifeCycleWidgetState createState() => _LifeCycleWidgetState();
}

class _LifeCycleWidgetState extends State<LifeCycleWidget> {
  @override
  void initState() {
    widget.preInit();
    Timer.run(() => widget.init.call(context));
    super.initState();
  }

  @override
  void dispose() {
    widget.dispose.call(context);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
