import 'package:dart_board_core/dart_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test Setup
///

/// TestFeature allows a variety of registrations
/// with varying features.
///
/// This lets me excercise DartBoardCore by registering the features
/// making sure they work, and manipulating the interface
/// to see ithings update correctly.
///
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

  /// We register 2 routes, using the 2 classes
  /// available
  ///
  /// Route2 is optional if it's given a name or not.
  @override
  List<RouteDefinition> get routes => [
        MapRouteDefinition(routeMap: {
          route1: (ctx, settings) => Material(
                  child: Column(
                children: [
                  MaterialButton(
                      onPressed: () {
                        if (route2 != null) {
                          /// If we have a second route, this will push to it
                          DartBoardCore.nav.push(route2!);
                        } else {
                          // If not, lets 404
                          DartBoardCore.nav.push('/expected_404');
                        }
                      },
                      child: Text('$namespace:$implementationName')),
                ],
              ))
        }),
        if (route2 != null)
          NamedRouteDefinition(
              //routeBuilder: kMaterialRouteResolver,
              route: route2!,
              builder: (ctx, settings) => Material(
                  child: Text('$namespace:${implementationName}_secondary')))
      ];

  /// A decoration we install
  @override
  List<DartBoardDecoration> get appDecorations =>
      [getTestDecoration('app_decoration')];

  /// Another decoration we install (page)
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

///----------------------------------------------------------------------------
/// Tests
void main() {
  testWidgets('404 With no Features', (tester) async {
    await tester.pumpWidget(DartBoard(
      initialPath: '/a',
      features: [],
    ));

    // Make sure DartBoard as started fully
    await tester.pumpAndSettle();

    // Nothing is registered, so this should be 404 message
    // Checking for default
    expect(find.text('404\n"/a" Not Found'), findsOneWidget);
  });

  testWidgets('Check page navigation', (tester) async {
    await tester.pumpWidget(DartBoard(
      initialPath: '/main',
      routeBuilder: kMaterialRouteResolver,
      features: [
        TestFeature(
            namespace: 'namespace', route1: '/main', route2: '/secondary')
      ],
    ));

    // Make sure DartBoard as started fully
    await tester.pumpAndSettle();
    await tester.tap(find.text('namespace:default'));
    await tester.pumpAndSettle(Duration(seconds: 2));
    expect(find.text('namespace:default_secondary'), findsOneWidget);
  });

  testWidgets('Test Find Feature', (tester) async {
    await tester.pumpWidget(DartBoard(
      initialPath: '/main',
      routeBuilder: kMaterialRouteResolver,
      features: [
        TestFeature(
            namespace: 'namespace', route1: '/main', route2: '/secondary')
      ],
    ));

    // Make sure DartBoard as started fully
    await tester.pumpAndSettle();
    final feature = DartBoardCore.instance.findByName('namespace');

    expect(feature is TestFeature, equals(true));

    final emptyFeature =
        DartBoardCore.instance.findByName('namespace_not_found');

    expect(emptyFeature is EmptyDartBoardFeature, equals(true));
    expect(emptyFeature.toString(), equals('Empty'));
  });

  testWidgets('Check page navigation to a 404', (tester) async {
    await tester.pumpWidget(DartBoard(
      initialPath: '/main',
      features: [TestFeature(namespace: 'namespace', route1: '/main')],
    ));

    // Make sure DartBoard as started fully
    await tester.pumpAndSettle();
    await tester.tap(find.text('namespace:default'));
    await tester.pumpAndSettle();
    expect(find.text('404\n"/expected_404" Not Found'), findsOneWidget);
  });

  testWidgets('Page and App Decoration Check', (tester) async {
    await tester.pumpWidget(DartBoard(
      initialPath: '/main',
      features: [TestFeature(namespace: 'default', route1: '/main')],
    ));

    // Make sure DartBoard as started fully
    await tester.pumpAndSettle();

    // Nothing is registered, so this should be 404 message
    // Checking for default
    expect(find.text('app_decoration'), findsOneWidget);
    expect(find.text('page_decoration'), findsOneWidget);
  });

  testWidgets('Check Route Exists', (tester) async {
    await tester.pumpWidget(DartBoard(initialPath: '/main', features: [
      TestFeature(
        namespace: 'default',
        route1: '/main',
      )
    ]));

    // Make sure DartBoard as started fully
    await tester.pumpAndSettle();

    // Nothing is registered, so this should be 404 message
    // Checking for default

    expect(DartBoardCore.instance.confirmRouteExists('/main'), equals(true));
    expect(DartBoardCore.instance.confirmRouteExists('/does_not_exist'),
        equals(false));
  });

  testWidgets('Page and App Decoration Check - AllowList:Pass', (tester) async {
    await tester.pumpWidget(DartBoard(
      initialPath: '/main',
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
      initialPath: '/main',
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
      initialPath: '/main',
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
      initialPath: '/main',
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
      initialPath: '/main',
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
