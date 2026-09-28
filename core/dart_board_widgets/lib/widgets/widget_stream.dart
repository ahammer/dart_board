import 'dart:async';

import 'package:flutter/cupertino.dart';

/// The idea here is that this widget gets an async *, and can yield portions of the tree as it goes
///
/// e.g.
/// ```
/// yield ProgressBar()
/// await someThingToHappen
/// yield Error or Results
/// ```
class WidgetStream extends StatefulWidget {
  final Stream<Widget> Function(BuildContext context) widgetProducer;

  const WidgetStream(this.widgetProducer, {Key? key}) : super(key: key);

  @override
  State<WidgetStream> createState() => _WidgetStreamState();
}

class _WidgetStreamState extends State<WidgetStream> {
  Widget _streamedWidget = Container();
  late StreamSubscription<Widget> _subscription;

  @override
  void setState(VoidCallback fn) {
    /// Lets not do this if we aren't mounted
    if (!mounted) return;
    super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    _subscription = widget.widgetProducer(context).listen(
        (element) => setState(() {
              _streamedWidget = element;
            }),
        cancelOnError: true);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _streamedWidget;
}
