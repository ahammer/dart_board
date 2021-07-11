import 'package:dart_board_core/dart_board.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('404 With no Features', (tester) async {
    await tester.pumpWidget(DartBoard(
      initialRoute: '/a',
      features: [],
    ));

    // Make sure DartBoard as started fully
    await tester.pumpAndSettle();

    // Nothing is registered, so this should be 404 message
    // Checking for default
    expect(find.text('"/a" Not Found'), findsOneWidget);
  });

  testWidgets('Page and App Decoration Check', (tester) async {
    await tester.pumpWidget(DartBoard(
      initialRoute: '/main',
      features: [TestFeature(namespace: 'default', route1: '/main')],
    ));

    // Make sure DartBoard as started fully
    await tester.pumpAndSettle();

    // Nothing is registered, so this should be 404 message
    // Checking for default
    expect(find.text('app_decoration'), findsOneWidget);
    expect(find.text('page_decoration'), findsOneWidget);
  });

  testWidgets('Page and App Decoration Check - AllowList:Pass', (tester) async {
    await tester.pumpWidget(DartBoard(
      initialRoute: '/main',
      features: [
        TestFeature(
            namespace: 'default',
            route1: '/main',
            pageDecorationAllowList: ['/main:page_decoration'])
      ],
    ));

    // Make sure DartBoard as started fully
    await tester.pumpAndSettle();

    // Nothing is registered, so this should be 404 message
    // Checking for default

    expect(find.text('page_decoration'), findsOneWidget);
  });

  testWidgets('Page and App Decoration Check - AllowList:Fail', (tester) async {
    await tester.pumpWidget(DartBoard(
      initialRoute: '/main',
      features: [
        TestFeature(
            namespace: 'default',
            route1: '/main',
            pageDecorationAllowList: ['/does_not_exist:page_decoration'])
      ],
    ));

    await tester.pumpAndSettle();
    expect(find.text('page_decoration'), findsNothing);
  });

  testWidgets('Page and App Decoration Check - DenyList:Match and Block',
      (tester) async {
    await tester.pumpWidget(DartBoard(
      initialRoute: '/main',
      features: [
        TestFeature(
            namespace: 'default',
            route1: '/main',
            pageDecorationDenyList: ['/main:page_decoration'])
      ],
    ));

    // Make sure DartBoard as started fully
    await tester.pumpAndSettle();

    // Nothing is registered, so this should be 404 message
    // Checking for default

    expect(find.text('page_decoration'), findsNothing);
  });

  testWidgets('Page and App Decoration Check - DenyList:Does Not Match',
      (tester) async {
    await tester.pumpWidget(DartBoard(
      initialRoute: '/main',
      features: [
        TestFeature(
            namespace: 'default',
            route1: '/main',
            pageDecorationDenyList: ['/does_not_exist:page_decoration'])
      ],
    ));

    await tester.pumpAndSettle();
    expect(find.text('page_decoration'), findsOneWidget);
  });

  /// This test verifies that Features can be enabled/disabled and that Routing
  /// updated correspondingly.
  testWidgets('Feature Toggle and Routing', (tester) async {
    await tester.pumpWidget(DartBoard(
      initialRoute: '/main',
      features: [
        /// We register 3 test features
        TestFeature(
            namespace: 'Primary', route1: '/main', implementationName: 'a'),
        TestFeature(
            namespace: 'Primary', route1: '/main', implementationName: 'b'),
        TestFeature(
            namespace: 'Secondary', route1: '/main', implementationName: 'c'),
      ],
    ));

    // Make sure DartBoard as started fully
    await tester.pumpAndSettle();
    expect(DartBoardCore.instance.isFeatureActive('Primary'), equals(true));
    // Nothing is registered, so this should be 404 message
    // Checking for default
    expect(find.text('Primary:a'), findsOneWidget);

    /// Select "B" and verify it's what we see
    DartBoardCore.instance.setFeatureImplementation('Primary', 'b');
    await tester.pumpAndSettle();
    expect(DartBoardCore.instance.isFeatureActive('Primary'), equals(true));
    expect(find.text('Primary:b'), findsOneWidget);

    /// Disable "Primary" and verify it's what we see
    DartBoardCore.instance.setFeatureImplementation('Primary', null);

    await tester.pumpAndSettle();
    expect(DartBoardCore.instance.isFeatureActive('Primary'), equals(false));

    expect(find.text('Secondary:c'), findsOneWidget);
  });
}

class TestFeature extends DartBoardFeature {
  @override
  final String implementationName;
  final String route1;
  final String? route2;

  @override
  final String namespace;

  @override
  final List<String> pageDecorationAllowList;

  @override
  final List<String> pageDecorationDenyList;

  TestFeature({
    required this.namespace,
    required this.route1,
    this.route2,
    this.implementationName = 'default',
    this.pageDecorationAllowList = const [],
    this.pageDecorationDenyList = const [],
  });

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: route1,
            builder: (settings, ctx) =>
                Material(child: Text('$namespace:$implementationName'))),
        if (route2 != null)
          NamedRouteDefinition(
              route: route2!,
              builder: (settings, ctx) =>
                  Material(child: Text('$namespace:$implementationName:B')))
      ];

  @override
  List<DartBoardDecoration> get appDecorations =>
      [getTestDecoration('app_decoration')];

  @override
  List<DartBoardDecoration> get pageDecorations =>
      [getTestDecoration('page_decoration')];
}

DartBoardDecoration getTestDecoration(String label) => DartBoardDecoration(
    decoration: (ctx, child) => Column(
          children: [
            Text(label),
            Expanded(child: child),
          ],
        ),
    name: label);
