import 'package:dart_board_core/dart_board.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(DartBoard(features: [Nav2Feature()], initialRoute: '/home'));
}

class Nav2Feature extends DartBoardFeature {
  @override
  String get namespace => 'nav2';

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: '/home', builder: (ctx, settings) => HomePage()),
        PathedRouteDefinition([
          /// Level 0
          [
            NamedRouteDefinition(
                route: '/root',
                builder: (ctx, settings) => Scaffold(
                    appBar: AppBar(
                      title: Text(Nav.currentRoute),
                    ),
                    body: Column(
                      children: [Text('Root'), RouteNavigatorWidget()],
                    ))),
          ],

          /// Level 1 (e.g. /root/cata)
          [
            NamedRouteDefinition(
                route: '/cata',
                builder: (ctx, settings) => Scaffold(
                    appBar: AppBar(),
                    body: Column(
                      children: [Text('A'), RouteNavigatorWidget()],
                    ))),
            NamedRouteDefinition(
                route: '/catb',
                builder: (ctx, settings) => Scaffold(
                    appBar: AppBar(),
                    body: Column(
                      children: [Text('B'), RouteNavigatorWidget()],
                    )))
          ],

          /// Level 2
          [
            NamedRouteDefinition(
                route: '/details',
                builder: (ctx, settings) => Scaffold(
                    appBar: AppBar(),
                    body: Column(
                      children: [Text('Details'), RouteNavigatorWidget()],
                    )))
          ],
        ])
      ];
}

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(child: Center(child: RouteNavigatorWidget()));
  }
}

class RouteNavigatorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 600,
      child: Card(
        child: Row(
          children: [
            Column(
              children: [
                MaterialButton(
                    onPressed: () {
                      Nav.pushRoute('/root/cata/details');
                    },
                    child: Text('Go To Details')),
              ],
            ),
            Expanded(
              child: Column(
                children: [Text('r1')],
              ),
            )
          ],
        ),
      ),
    );
  }
}
