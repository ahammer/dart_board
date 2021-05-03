import 'package:dart_board_interface/dart_board_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';

class ScaffoldWithDrawerDecoration extends StatelessWidget {
  final Widget child;
  const ScaffoldWithDrawerDecoration({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ;
    return Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                child: Card(
                  child: Text(
                    "SECTIONS",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ),
              ...DartBoardCore.getRoutes().map(
                (e) => MaterialButton(
                  child: Text(
                    "$e",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed("$e");
                  },
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(title: Text("Example App")),
        body: child);
  }
}
