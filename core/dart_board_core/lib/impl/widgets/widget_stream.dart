import 'package:flutter/cupertino.dart';

/// The idea here is that this widget gets an async *, and can yield portions of the tree as it goes
///
/// e.g.
///
///
/// yield ProgressBar()
/// await someThingToHappen
/// yield Error or Results
///

class WidgetStream extends StatefulWidget {
  final Stream<Widget> Function(BuildContext context) widgetProducer;

  const WidgetStream(this.widgetProducer, {Key? key}) : super(key: key);

  @override
  State<WidgetStream> createState() => _WidgetStreamState();
}

class _WidgetStreamState extends State<WidgetStream> {
  Widget _streamedWidget = Container();

  @override
  void initState() {
    super.initState();
    widget.widgetProducer(context).forEach((element) => setState(() {
          _streamedWidget = element;
        }));
  }

  @override
  Widget build(BuildContext context) => _streamedWidget;
}
