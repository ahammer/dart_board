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
            route: '/test', builder: (ctx, settings) => const Test1Widget()),
        NamedRouteDefinition(
            route: '/test2', builder: (ctx, settings) => const Test2Widget()),
        NamedRouteDefinition(
            route: '/home', builder: (ctx, settings) => HomePage()),
        PathedRouteDefinition([
          /// Level 0
          [
            NamedRouteDefinition(
                route: '/root', builder: (ctx, settings) => const RootWidget()),
          ],

          /// Level 1 (e.g. /root/cata)
          [
            NamedRouteDefinition(
                route: '/cata', builder: (ctx, settings) => const CatAWidget()),
            NamedRouteDefinition(
                route: '/catb', builder: (ctx, settings) => const CatBWidget())
          ],

          /// Level 2
          [
            NamedRouteDefinition(
                route: '/details',
                builder: (ctx, settings) => const DetailsScreen())
          ],
        ])
      ];
}

class Test1Widget extends StatelessWidget {
  const Test1Widget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(DartBoardCore.nav.currentRoute),
        ),
        body: Column(
          children: [Text('Test'), RouteNavigatorWidget()],
        ));
  }
}

class Test2Widget extends StatelessWidget {
  const Test2Widget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(DartBoardCore.nav.currentRoute),
        ),
        body: Column(
          children: [Text('Test2'), RouteNavigatorWidget()],
        ));
  }
}

class RootWidget extends StatelessWidget {
  const RootWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(DartBoardCore.nav.currentRoute),
        ),
        body: Column(
          children: [Text('Root'), RouteNavigatorWidget()],
        ));
  }
}

class CatAWidget extends StatelessWidget {
  const CatAWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(DartBoardCore.nav.currentRoute),
        ),
        body: Column(
          children: [Text('A'), RouteNavigatorWidget()],
        ));
  }
}

class CatBWidget extends StatelessWidget {
  const CatBWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(DartBoardCore.nav.currentRoute),
      ),
      body: Column(
        children: [Text('B'), RouteNavigatorWidget()],
      ));
}

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(DartBoardCore.nav.currentRoute),
        ),
        body: Column(
          children: [Text('Details'), RouteNavigatorWidget()],
        ));
  }
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
  const RouteNavigatorWidget();

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
                      DartBoardCore.nav.push('/root/cata/details');
                    },
                    child: Text('Go To Details -> Direct')),
                MaterialButton(
                    onPressed: () {
                      DartBoardCore.nav
                          .push('/root/cata/details', expanded: true);
                    },
                    child: Text('Go To Details -> Stack')),
                MaterialButton(
                    onPressed: () {
                      DartBoardCore.nav.push('/test');
                    },
                    child: Text('Go To Test')),
                MaterialButton(
                    onPressed: () {
                      DartBoardCore.nav.push('/test2');
                    },
                    child: Text('Go To Test2')),
                MaterialButton(
                    onPressed: () {
                      DartBoardCore.nav.clearWhere((e) {
                        return e.path.contains('test');
                      });
                    },
                    child: Text('Clear test')),
                MaterialButton(
                    onPressed: () {
                      DartBoardCore.nav.replaceTop('/test2');
                    },
                    child: Text('Replace Top')),
                MaterialButton(
                    onPressed: () {
                      DartBoardCore.nav.clearWhere((path) => true);
                    },
                    child: Text('Clear')),
                MaterialButton(
                    onPressed: () {
                      DartBoardCore.nav.popUntil((e) => e.path == '/test2');
                    },
                    child: Text('Pop until /test2')),
                MaterialButton(
                    onPressed: () {
                      DartBoardCore.nav.pop();
                    },
                    child: Text('Pop')),
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
  Widget build(BuildContext context) =>
      DartBoardCore.nav.changeNotifier.builder((context, value) => Column(
          children: DartBoardCore.nav.stack
              .map((e) => Text('${e.path} ${e.hashCode}'))
              .toList()));
}
