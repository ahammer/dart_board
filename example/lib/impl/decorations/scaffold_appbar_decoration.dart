import 'package:flutter/material.dart';

class ScaffoldWithDrawerDecoration extends StatelessWidget {
  final Widget child;
  const ScaffoldWithDrawerDecoration({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              MaterialButton(
                child: Text("Go to /hello_word"),
                onPressed: () {
                  Navigator.of(context).pushNamed("/hello_world");
                },
              ),
              MaterialButton(
                child: Text("Go to /hello_word_2"),
                onPressed: () {
                  Navigator.of(context).pushNamed("/hello_world_2");
                },
              )
            ],
          ),
        ),
        appBar: AppBar(title: Text("Example App")),
        body: child);
  }
}
