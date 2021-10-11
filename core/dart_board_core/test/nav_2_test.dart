import 'package:dart_board_core/dart_board_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Test Initial Route', (tester) async {
    await tester.pumpWidget(DartBoard(
      features: [NavTestFeature()],
      initialPath: '/a',
    ));

    expect(find.text('/a'), findsOneWidget);
    expect(DartBoardCore.nav.stack.length, equals(1));
  });

  testWidgets('Test Replace Inital Route', (tester) async {
    await tester.pumpWidget(DartBoard(
      features: [NavTestFeature()],
      initialPath: '/a',
    ));

    DartBoardCore.nav.replaceRoot('/b');
    await tester.pumpAndSettle();
    expect(find.text('/b'), findsOneWidget);
    expect(DartBoardCore.nav.stack.length, equals(1));
  });

  testWidgets('Test Push', (tester) async {
    await tester.pumpWidget(DartBoard(
      features: [NavTestFeature()],
      initialPath: '/a',
    ));

    DartBoardCore.nav.push('/b');
    await tester.pumpAndSettle();
    expect(find.text('/b'), findsOneWidget);
    expect(DartBoardCore.nav.stack.length, equals(2));
  });

  testWidgets('Test Push & Pop Route', (tester) async {
    await tester.pumpWidget(DartBoard(
      features: [NavTestFeature()],
      initialPath: '/a',
    ));

    DartBoardCore.nav.push('/b');
    await tester.pumpAndSettle();
    expect(find.text('/b'), findsOneWidget);
    expect(DartBoardCore.nav.stack.length, equals(2));

    DartBoardCore.nav.pop();
    await tester.pumpAndSettle();
    expect(find.text('/a'), findsOneWidget);
    expect(DartBoardCore.nav.stack.length, equals(1));
  });

  testWidgets('Test Push & Replace Top', (tester) async {
    await tester.pumpWidget(DartBoard(
      features: [NavTestFeature()],
      initialPath: '/a',
    ));

    DartBoardCore.nav.push('/b');
    await tester.pumpAndSettle();
    expect(find.text('/b'), findsOneWidget);

    DartBoardCore.nav.replaceTop('/c');
    await tester.pumpAndSettle();
    expect(find.text('/c'), findsOneWidget);

    expect(DartBoardCore.nav.stack.length, equals(2));
  });

  testWidgets('Test Deep Path Expansion', (tester) async {
    await tester.pumpWidget(DartBoard(
      features: [NavTestFeature()],
      initialPath: '/a',
    ));

    DartBoardCore.nav.push('/shallow_a/deep_a/someurl', expanded: true);
    await tester.pumpAndSettle();
    expect(find.text('/shallow_a/deep_a/someurl'), findsOneWidget);
    expect(DartBoardCore.nav.stack.length, equals(4));

    DartBoardCore.nav.pop();
    await tester.pumpAndSettle();
    expect(find.text('/deep_a'), findsOneWidget);
    expect(DartBoardCore.nav.stack.length, equals(3));

    DartBoardCore.nav.pop();
    await tester.pumpAndSettle();
    expect(find.text('/shallow_a'), findsOneWidget);
    expect(DartBoardCore.nav.stack.length, equals(2));

    DartBoardCore.nav.pop();
    await tester.pumpAndSettle();
    expect(find.text('/a'), findsOneWidget);
    expect(DartBoardCore.nav.stack.length, equals(1));
  });

  testWidgets('Test Pop Until', (tester) async {
    await tester.pumpWidget(DartBoard(
      features: [NavTestFeature()],
      initialPath: '/a',
    ));

    DartBoardCore.nav.push('/shallow_a/deep_a/someurl', expanded: true);
    await tester.pumpAndSettle();
    expect(find.text('/shallow_a/deep_a/someurl'), findsOneWidget);
    expect(DartBoardCore.nav.stack.length, equals(4));

    DartBoardCore.nav.popUntil((e) => e.path == '/shallow_a');
    await tester.pumpAndSettle();
    expect(find.text('/shallow_a'), findsOneWidget);
    expect(DartBoardCore.nav.stack.length, equals(2));
  });
  testWidgets('Test Clear Where', (tester) async {
    /// Push 3 routes, delete the middle one
    ///
    await tester.pumpWidget(DartBoard(
      features: [NavTestFeature()],
      initialPath: '/a',
    ));

    DartBoardCore.nav.push('/b');
    DartBoardCore.nav.push('/c');
    expect(DartBoardCore.nav.stack.length, equals(3));
    DartBoardCore.nav.clearWhere((path) => path.path == '/b');
    expect(DartBoardCore.nav.stack.length, equals(2));
    await tester.pumpAndSettle();
    expect(find.text('/c'), findsOneWidget);
    DartBoardCore.nav.pop();
    await tester.pumpAndSettle();
    expect(find.text('/a'), findsOneWidget);
  });
}

class NavTestFeature extends DartBoardFeature {
  @override
  String get namespace => 'nav_test';

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: '/a', builder: (ctx, settings) => RouteDisplay(route: '/a')),
        NamedRouteDefinition(
            route: '/b', builder: (ctx, settings) => RouteDisplay(route: '/b')),
        NamedRouteDefinition(
            route: '/c', builder: (ctx, settings) => RouteDisplay(route: '/c')),
        NamedRouteDefinition(
            route: '/d', builder: (ctx, settings) => RouteDisplay(route: '/d')),
        PathedRouteDefinition([
          [
            NamedRouteDefinition(
                route: '/shallow_a',
                builder: (ctx, settings) => RouteDisplay(route: '/shallow_a')),
            NamedRouteDefinition(
                route: '/shallow_b',
                builder: (ctx, settings) => RouteDisplay(route: '/shallow_b')),
          ],
          [
            NamedRouteDefinition(
                route: '/deep_a',
                builder: (ctx, settings) => RouteDisplay(route: '/deep_a')),
          ],
          [
            UriRoute((ctx, uri) => RouteDisplay(route: uri.toString())),
          ]
        ])
      ];
}

class RouteDisplay extends StatelessWidget {
  final String route;

  const RouteDisplay({Key? key, required this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) => Material(child: Text(route));
}
