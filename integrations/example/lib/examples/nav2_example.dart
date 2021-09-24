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
            route: '/test',
            builder: (ctx, settings) => Scaffold(
                appBar: AppBar(
                  title: Text(Nav.currentRoute),
                ),
                body: Column(
                  children: [Text('Test'), RouteNavigatorWidget()],
                ))),
        NamedRouteDefinition(
            route: '/test2',
            builder: (ctx, settings) => Scaffold(
                appBar: AppBar(
                  title: Text(Nav.currentRoute),
                ),
                body: Column(
                  children: [Text('Test2'), RouteNavigatorWidget()],
                ))),
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
                    appBar: AppBar(
                      title: Text(Nav.currentRoute),
                    ),
                    body: Column(
                      children: [Text('A'), RouteNavigatorWidget()],
                    ))),
            NamedRouteDefinition(
                route: '/catb',
                builder: (ctx, settings) => Scaffold(
                    appBar: AppBar(
                      title: Text(Nav.currentRoute),
                    ),
                    body: Column(
                      children: [Text('B'), RouteNavigatorWidget()],
                    )))
          ],

          /// Level 2
          [
            NamedRouteDefinition(
                route: '/details',
                builder: (ctx, settings) => Scaffold(
                    appBar: AppBar(
                      title: Text(Nav.currentRoute),
                    ),
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
                MaterialButton(
                    onPressed: () {
                      Nav.pushRoute('/test');
                    },
                    child: Text('Go To Test')),
                MaterialButton(
                    onPressed: () {
                      Nav.pushRoute('/test2');
                    },
                    child: Text('Go To Test2')),
                MaterialButton(
                    onPressed: () {
                      Nav.clearWhere((e) {
                        return e.path.contains('test');
                      });
                    },
                    child: Text('Clear test')),
              ],
            ),
            Expanded(
              child: CurrentNavStack(),
            )
          ],
        ),
      ),
    );
  }
}

class CurrentNavStack extends StatelessWidget {
  const CurrentNavStack({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Nav.changeNotifier.builder((context, value) =>
        Column(children: Nav.stack.map((e) => Text(e.path)).toList()));
  }
}
