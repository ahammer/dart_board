import '../../dart_board.dart';

/// ChangeNotifierBuilder Extension
///
/// Have you ever wanted to go
///
/// someChangeNotifier.builder((ctx, val)=>build);
///
/// That's what this is for, so you can convert ChangeNotifiers into widgets
///
///
extension ChangeNotifierBuilderExtension on ChangeNotifier {
  Widget builder<T extends ChangeNotifier>(
          Widget Function(BuildContext context, T value) handler) =>
      ChangeNotifierBuilder<T>(notifier: this as T, builder: handler);
}

/// Takes a ChangeNotifier and Builds with It
class ChangeNotifierBuilder<T extends ChangeNotifier> extends StatefulWidget {
  final Widget Function(BuildContext context, T value) builder;
  final T notifier;

  const ChangeNotifierBuilder(
      {Key? key, required this.builder, required this.notifier})
      : super(key: key);

  @override
  _ChangeNotifierBuilderState createState() => _ChangeNotifierBuilderState();
}

class _ChangeNotifierBuilderState<T extends ChangeNotifier>
    extends State<ChangeNotifierBuilder<T>> {
  void onUpdate() => setState(() {});

  @override
  void initState() {
    widget.notifier.addListener(onUpdate);
    super.initState();
  }

  @override
  void dispose() {
    widget.notifier.removeListener(onUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, widget.notifier);
}
