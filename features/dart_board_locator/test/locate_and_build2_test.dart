import 'package:dart_board_core/dart_board_core.dart';
import 'package:dart_board_locator/dart_board_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _Counter extends ValueNotifier<int> {
  _Counter() : super(0);
}

class _LocatorTestFeature extends DartBoardFeature {
  final counters = <_Counter>[];
  var builderCalls = 0;

  @override
  String get namespace => 'locator_test';

  @override
  List<DartBoardFeature> get dependencies => [DartBoardLocatorFeature()];

  @override
  List<DartBoardDecoration> get appDecorations => [
        LocatorDecoration<_Counter>(() {
          final counter = _Counter();
          counters.add(counter);
          return counter;
        })
      ];

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
          route: '/probe',
          builder: (_, __) => locateAndBuild2<_Counter, _Counter>(
            (_, first, second) {
              builderCalls++;
              return Text('${first.value}/${second.value}');
            },
            instanceId1: 'left',
            instanceId2: 'right',
          ),
        )
      ];
}

void main() {
  testWidgets('locates and listens to two notifier instances', (tester) async {
    final feature = _LocatorTestFeature();
    await tester.pumpWidget(
      DartBoard(features: [feature], initialPath: '/probe'),
    );
    await tester.pumpAndSettle();

    expect(find.text('0/0'), findsOneWidget);

    locate<_Counter>(instanceId: 'left').value = 1;
    await tester.pumpAndSettle();
    expect(find.text('1/0'), findsOneWidget);

    locate<_Counter>(instanceId: 'right').value = 2;
    await tester.pumpAndSettle();
    expect(find.text('1/2'), findsOneWidget);
    expect(feature.builderCalls, greaterThan(0));

    await tester.pumpWidget(const SizedBox());
    for (final counter in feature.counters) {
      counter.dispose();
    }
  });
}
