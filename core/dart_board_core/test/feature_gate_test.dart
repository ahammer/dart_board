import 'package:dart_board_core/dart_board_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class FeatureA extends DartBoardFeature {
  @override
  String get namespace => 'FeatureA';
}

class FeatureB extends DartBoardFeature {
  final bool blocking;

  FeatureB({required this.blocking});

  @override
  String get namespace => 'FeatureB';

  @override
  List<DartBoardDecoration> get pageDecorations => [
        FeatureGatePageDecoration('FeatureA', autoEnable: !blocking),
      ];

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: '/main',
            builder: (ctx, settings) => Card(
                  child: Text('test passed'),
                ))
      ];

  @override
  List<DartBoardFeature> get dependencies => [FeatureA()];
}

void main() {
  testWidgets('Check the Feature-Gate: Non-Blocking mode', (tester) async {
    await tester.pumpWidget(DartBoard(
      featureOverrides: {'FeatureA': null},
      features: [FeatureB(blocking: false)],
      initialPath: '/main',
    ));

    await tester.pumpAndSettle();

    expect(find.text('test passed'), findsOneWidget);
  });

  testWidgets('Check the Feature-Gate: Blocking mode', (tester) async {
    await tester.pumpWidget(DartBoard(
      featureOverrides: {'FeatureA': null},
      features: [FeatureB(blocking: true)],
      initialPath: '/main',
    ));
    await tester.pumpAndSettle(Duration(seconds: 1));

    expect(find.byKey(ValueKey('RequiredFeatureText')), findsOneWidget);
    await tester.tap(find.byKey(ValueKey('EnableFeatureButton')));
    await tester.pumpAndSettle();

    expect(find.text('test passed'), findsOneWidget);
  });
}
