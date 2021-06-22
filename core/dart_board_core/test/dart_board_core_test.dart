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
      features: [TestFeature(namespace: 'default', route: '/main')],
    ));

    // Make sure DartBoard as started fully
    await tester.pumpAndSettle();

    // Nothing is registered, so this should be 404 message
    // Checking for default
    expect(find.text('app_decoration'), findsOneWidget);
    expect(find.text('page_decoration'), findsOneWidget);
  });

  testWidgets('Feature Toggle and Routing', (tester) async {
    await tester.pumpWidget(DartBoard(
      initialRoute: '/main',
      features: [
        /// We register 3 test features
        TestFeature(namespace: 'Primary', route: 'a'),
        TestFeature(namespace: 'Primary', route: 'b'),
        TestFeature(namespace: 'Secondary', route: 'c'),
        ],
    ));

    // Make sure DartBoard as started fully
    await tester.pumpAndSettle();

    // Nothing is registered, so this should be 404 message
    // Checking for default
    expect(find.text('Primary:a'), findsOneWidget);

    /// Select "B" and verify it's what we see
    DartBoardCore.instance.setFeatureImplementation('Primary', 'b');
    await tester.pumpAndSettle();
    expect(find.text('Primary:b'), findsOneWidget);


    /// Disable "Primary" and verify it's what we see
    DartBoardCore.instance.setFeatureImplementation('Primary', null);
    await tester.pumpAndSettle();
    expect(find.text('Secondary:c'), findsOneWidget);

  });
}

class TestFeature extends DartBoardFeature {
  final String route;

  @override
  final String namespace;
  
  @override
  String get implementationName => route;

  TestFeature({required this.namespace, required this.route});
  
  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: '/main',
            builder: (settings, ctx) =>
                Material(child: Text('$namespace:$route')))
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
            Expanded(child:child),
          ],
        ),
    name: 'tester');
