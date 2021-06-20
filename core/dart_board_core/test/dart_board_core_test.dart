import 'package:dart_board_core/dart_board.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('404 With no Features', (tester) async {
    await tester.pumpWidget(DartBoard(
      initialRoute: '/main',
      features: [],
    ));

    // Make sure DartBoard as started fully
    await tester.pumpAndSettle();

    // Nothing is registered, so this should be 404 message
    // Checking for default
    expect(find.text('"/main" Not Found'), findsOneWidget);
  });

  testWidgets('Basic Entry Point Loading', (tester) async {
    await tester.pumpWidget(DartBoard(
      initialRoute: '/main',
      features: [TestFeature()],
    ));

    // Make sure DartBoard as started fully
    await tester.pumpAndSettle();

    // Nothing is registered, so this should be 404 message
    // Checking for default
    expect(find.text('main displayed'), findsOneWidget);
  });
}

class TestFeature extends DartBoardFeature {
  @override
  String get namespace => 'test_feature';

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: '/main',
            builder: (settings, ctx) =>
                Material(child: Text('main displayed')))
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
