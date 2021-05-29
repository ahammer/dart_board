import '../../dart_board.dart';

class Rebuilder extends StatefulWidget {
  final GetRebuilder rebuilder;

  const Rebuilder({Key? key, required this.rebuilder}) : super(key: key);

  @override
  _RebuilderState createState() => _RebuilderState();
}

typedef GetRebuilder = Function() Function();

class _RebuilderState extends State<Rebuilder> {
  late final Widget child;

  void triggerRebuild() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => child;
}
