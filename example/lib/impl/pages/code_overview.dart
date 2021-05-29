import 'package:dart_board_core/dart_board.dart';
import 'package:example/data/constants.dart';
import 'package:flutter/cupertino.dart';

class CodeOverview extends StatefulWidget {
  @override
  _CodeOverviewState createState() => _CodeOverviewState();
}

class _CodeOverviewState extends State<CodeOverview>
    with SingleTickerProviderStateMixin {
  late final _controller;

  @override
  void initState() {
    _controller = TabController(length: kCodeRoutes.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                  controller: _controller,
                  children: kCodeRoutes
                      .map((e) => RouteWidget(
                            settings: RouteSettings(name: e['route']),
                          ))
                      .toList()),
            ),
            Material(
              color: Theme.of(context).colorScheme.primary,
              child: TabBar(
                  controller: _controller,
                  tabs: kCodeRoutes
                      .map((e) => Tab(
                            text: e['route'],
                          ))
                      .toList()),
            )
          ],
        ),
      );
}
