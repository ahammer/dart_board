import 'package:dart_board_core/dart_board_core.dart';
import 'package:dart_board_emitter/dart_board_emitter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

abstract class _BaseEvent {}

class _ConcreteEvent implements _BaseEvent {}

class _ValuesReceiver<T> extends Receiver<T> {
  final values = <T>[];

  @override
  void receiver(T data) => values.add(data);
}

class _EmitterTestFeature extends DartBoardFeature {
  @override
  String get namespace => 'Emitter test';

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
          route: '/emitter-test',
          builder: (_, __) => const SizedBox(),
        ),
      ];
}

void main() {
  test('routes exact declared types and unregisters receivers', () {
    final emitter = DartBoardEmitter();
    final live = _ValuesReceiver<num>();
    final unrelated = _ValuesReceiver<int>();

    emitter.register<num>(live);
    emitter.register<int>(unrelated);
    emitter.emit<num>(1);

    final cached = _ValuesReceiver<num>();
    emitter.register<num>(cached, useCache: true);

    expect(live.values, [1]);
    expect(cached.values, [1]);
    expect(unrelated.values, isEmpty);

    emitter.unregister<num>(live);
    emitter.emit<num>(2);

    expect(live.values, [1]);
    expect(cached.values, [1, 2]);
    expect(unrelated.values, isEmpty);
  });

  testWidgets('top-level wrapper preserves a declared base type',
      (tester) async {
    await tester.pumpWidget(DartBoard(
      features: [DartBoardEmitter(), _EmitterTestFeature()],
      initialPath: '/emitter-test',
    ));

    final live = _ValuesReceiver<_BaseEvent>();
    registerReceiver<_BaseEvent>(live);
    emit<_BaseEvent>(_ConcreteEvent());

    final cached = _ValuesReceiver<_BaseEvent>();
    registerReceiver<_BaseEvent>(cached, useCache: true);

    expect(live.values, hasLength(1));
    expect(cached.values, hasLength(1));
    expect(live.values.single, isA<_ConcreteEvent>());
    expect(cached.values.single, isA<_ConcreteEvent>());

    unregisterReceiver<_BaseEvent>(live);
    emit<_BaseEvent>(_ConcreteEvent());

    expect(live.values, hasLength(1));
    expect(cached.values, hasLength(2));
  });
}
