import 'package:dart_board_core/dart_board.dart';

/// Type conversion widget
///
/// Takes an Input (From another Builder widget usually)
/// Gives an Output which is a chained callback
///
/// If Input doesn't change, or Output doesn't change, rebuild is avoided.
///
class Convertor<In, Out> extends StatefulWidget {
  final In input;
  final Out Function(In input) convertor;
  final Widget Function(BuildContext context, Out model) builder;

  const Convertor(
      {Key? key,
      required this.convertor,
      required this.builder,
      required this.input})
      : super(key: key);

  @override
  _ConvertorState<In, Out> createState() => _ConvertorState<In, Out>();
}

class _ConvertorState<In, Out> extends State<Convertor<In, Out>> {
  late In _current;
  late Out _value;

  @override
  void didUpdateWidget(covariant Convertor<In, Out> oldWidget) {
    if (_current == widget.input) return;
    final _newValue = widget.convertor(widget.input);
    if (_newValue == _value) return;

    setState(() {
      _current = widget.input;
      _value = widget.convertor(_current);
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _current = widget.input;
    _value = widget.convertor(_current);

    super.initState();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _value);
}
