import 'package:dart_board_core/dart_board.dart';

/// Converts a Builder from One type into Another
/// Caches values and doesn't rebuild unless model or conversion
/// changes
/// E.g. To generate a View Model
class BuilderConvertor<In, Out> extends StatefulWidget {
  final In input;
  final Out Function(In input) convertor;
  final Widget Function(BuildContext context, Out model) builder;

  const BuilderConvertor(
      {Key? key,
      required this.convertor,
      required this.builder,
      required this.input})
      : super(key: key);

  @override
  _BuilderConvertorState<In, Out> createState() =>
      _BuilderConvertorState<In, Out>();
}

class _BuilderConvertorState<In, Out> extends State<BuilderConvertor<In, Out>> {
  late In _current;
  late Out _value;

  @override
  void didUpdateWidget(covariant BuilderConvertor<In, Out> oldWidget) {
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
