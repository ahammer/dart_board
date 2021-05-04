import 'package:dart_board/impl/widgets/dart_board_nav_drawer.dart';
import 'package:flutter/material.dart';

class ScaffoldWithDrawerDecoration extends StatelessWidget {
  final Widget child;
  const ScaffoldWithDrawerDecoration({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
      home: Scaffold(
          drawer: DartBoardNavDrawer(),
          appBar: AppBar(title: Text("Example App")),
          body: child));
}
