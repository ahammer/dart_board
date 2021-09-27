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
            route: '/test', builder: (ctx, settings) => const NavTestPage()),
        NamedRouteDefinition(
            route: '/test2', builder: (ctx, settings) => const NavTestPage()),
        NamedRouteDefinition(
            route: '/home', builder: (ctx, settings) => NavTestPage()),
        PathedRouteDefinition([
          /// Level 0
          [
            NamedRouteDefinition(
                route: '/root',
                builder: (ctx, settings) => const NavTestPage()),
          ],

          /// Level 1 (e.g. /root/cata)
          [
            NamedRouteDefinition(
                route: '/cata',
                builder: (ctx, settings) => const NavTestPage()),
            NamedRouteDefinition(
                route: '/catb', builder: (ctx, settings) => const NavTestPage())
          ],

          /// Level 2
          [
            NamedRouteDefinition(
                route: '/details',
                builder: (ctx, settings) => const NavTestPage())
          ],
        ])
      ];
}

class NavTestPage extends StatelessWidget {
  const NavTestPage();

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text('${DartBoardCore.nav.currentRoute}'),
      ),
      body: Column(
        children: [
          Wrap(
            children: [
              _NavButton(
                  onPressed: () {
                    DartBoardCore.nav.push('/root/cata/details');
                  },
                  label: 'Go To Details -> Direct'),
              _NavButton(
                  onPressed: () {
                    DartBoardCore.nav
                        .push('/root/cata/details', expanded: true);
                  },
                  label: 'Go To Details -> Stack'),
              _NavButton(
                  onPressed: () {
                    DartBoardCore.nav.pushDynamic(
                        dynamicRouteName: 'test_route',
                        builder: (ctx) => const NavTestPage());
                  },
                  label: 'Push Dynamic'),
              _NavButton(
                  onPressed: () {
                    DartBoardCore.nav.push('/test');
                  },
                  label: 'Go To Test'),
              _NavButton(
                  onPressed: () {
                    DartBoardCore.nav.push('/test2');
                  },
                  label: 'Go To Test2'),
              _NavButton(
                  onPressed: () {
                    DartBoardCore.nav.clearWhere((e) {
                      return e.path.contains('test');
                    });
                  },
                  label: 'Clear test'),
              _NavButton(
                  onPressed: () {
                    DartBoardCore.nav.replaceTop('/test2');
                  },
                  label: 'Replace Top'),
              _NavButton(
                  onPressed: () {
                    DartBoardCore.nav.clearWhere((path) => true);
                  },
                  label: 'Clear'),
              _NavButton(
                onPressed: () =>
                    DartBoardCore.nav.popUntil((e) => e.path == '/test2'),
                label: 'Pop until /test2',
              ),
              _NavButton(
                onPressed: () => DartBoardCore.nav.pop(),
                label: 'Pop',
              ),
            ],
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                elevation: 2,
                child:
                    SizedBox(width: double.infinity, child: CurrentNavStack())),
          ))
        ],
      ));
}

class _NavButton extends StatelessWidget {
  final Function() onPressed;
  final String label;

  const _NavButton({Key? key, required this.onPressed, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
      elevation: 3,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(label),
        ),
      ));
}

class CurrentNavStack extends StatelessWidget {
  const CurrentNavStack({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      DartBoardCore.nav.changeNotifier.builder((context, value) => Column(
          children: DartBoardCore.nav.stack
              .map((e) => ListTile(title: Text('${e.path}')))
              .toList()));
}
