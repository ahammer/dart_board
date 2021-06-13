import 'package:dart_board_core/dart_board.dart';

/// Converts a Builder from One type into Another
/// E.g. To generate a View Model
class BuilderConvertor<In, Out> extends StatelessWidget {
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
  Widget build(BuildContext context) => builder(context, convertor(input));
}
