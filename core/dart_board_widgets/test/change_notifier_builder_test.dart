import 'package:dart_board_widgets/widgets/change_notifier_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _TrackedNotifier extends ChangeNotifier {
  int value = 0;
  bool get subscribed => hasListeners;

  void increment() {
    value++;
    notifyListeners();
  }
}

Widget _builderFor(List<_TrackedNotifier> notifiers, Widget Function() build) {
  switch (notifiers.length) {
    case 1:
      return ChangeNotifierBuilder<_TrackedNotifier>(
        notifier: notifiers[0],
        builder: (_, __) => build(),
      );
    case 2:
      return ChangeNotifierBuilder2<_TrackedNotifier, _TrackedNotifier>(
        notifier1: notifiers[0],
        notifier2: notifiers[1],
        builder: (_, __, ___) => build(),
      );
    case 3:
      return ChangeNotifierBuilder3<_TrackedNotifier, _TrackedNotifier,
          _TrackedNotifier>(
        notifier1: notifiers[0],
        notifier2: notifiers[1],
        notifier3: notifiers[2],
        builder: (_, __, ___, ____) => build(),
      );
    default:
      throw ArgumentError.value(notifiers.length, 'notifiers.length');
  }
}

void main() {
  // Verifies the Change Notifier is listening
  testWidgets('test ChangeNotifierBuilder widget', (tester) async {
    final notifier = MyState();
    await tester.pumpWidget(MaterialApp(
      home: ChangeNotifierBuilder<MyState>(
        notifier: notifier,
        builder: (ctx, val) {
          return Text(val.output);
        },
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.text('0'), findsOneWidget);
    notifier.increment();
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('test ChangeNotifierBuilder2 widget', (tester) async {
    final notifier = MyState();
    final notifier2 = MyState2();
    await tester.pumpWidget(MaterialApp(
      home: ChangeNotifierBuilder2<MyState, MyState2>(
        notifier1: notifier,
        notifier2: notifier2,
        builder: (ctx, val, val2) {
          return Text("${val.output} - ${val2.output}");
        },
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.text('0 - 0'), findsOneWidget);
    notifier.increment();
    await tester.pumpAndSettle();
    expect(find.text('1 - 0'), findsOneWidget);
    notifier2.increment();
    await tester.pumpAndSettle();
    expect(find.text('1 - 1'), findsOneWidget);
  });

  testWidgets('test ChangeNotifierBuilder3 widget', (tester) async {
    final notifier = MyState();
    final notifier2 = MyState2();
    final notifier3 = MyState3();

    await tester.pumpWidget(MaterialApp(
      home: ChangeNotifierBuilder3<MyState, MyState2, MyState3>(
        notifier1: notifier,
        notifier2: notifier2,
        notifier3: notifier3,
        builder: (ctx, val, val2, val3) {
          return Text("${val.output} - ${val2.output} - ${val3.output}");
        },
      ),
    ));
    await tester.pumpAndSettle();
    expect(find.text('0 - 0 - 0'), findsOneWidget);
    notifier.increment();
    await tester.pumpAndSettle();
    expect(find.text('1 - 0 - 0'), findsOneWidget);
    notifier2.increment();
    await tester.pumpAndSettle();
    expect(find.text('1 - 1 - 0'), findsOneWidget);
    notifier3.increment();
    await tester.pumpAndSettle();
    expect(find.text('1 - 1 - 1'), findsOneWidget);
  });

  testWidgets('test ChangeNotifierBuilder widget - Extension Syntax',
      (tester) async {
    final notifier = MyState();
    await tester.pumpWidget(MaterialApp(
        home:
            notifier.builder<MyState>((context, value) => Text(value.output))));
    await tester.pumpAndSettle();
    expect(find.text('0'), findsOneWidget);
    notifier.increment();
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);
  });

  for (final count in [1, 2, 3]) {
    testWidgets('ChangeNotifierBuilder$count follows replacements',
        (tester) async {
      final notifiers = List.generate(count, (_) => _TrackedNotifier());
      final allNotifiers = [...notifiers];
      var buildCount = 0;

      Widget buildWidget() => Directionality(
            textDirection: TextDirection.ltr,
            child: _builderFor(notifiers, () {
              buildCount++;
              return Text(
                  notifiers.map((notifier) => '${notifier.value}').join('/'));
            }),
          );

      await tester.pumpWidget(buildWidget());
      for (var position = 0; position < count; position++) {
        final oldNotifier = notifiers[position];
        final replacement = _TrackedNotifier();
        notifiers[position] = replacement;
        allNotifiers.add(replacement);
        await tester.pumpWidget(buildWidget());

        expect(oldNotifier.subscribed, isFalse);
        expect(notifiers.every((notifier) => notifier.subscribed), isTrue);

        final buildsBeforeOldNotification = buildCount;
        oldNotifier.increment();
        await tester.pumpAndSettle();
        expect(buildCount, buildsBeforeOldNotification);

        replacement.increment();
        await tester.pumpAndSettle();
        expect(buildCount, greaterThan(buildsBeforeOldNotification));
        expect(
          find.text(notifiers.map((notifier) => '${notifier.value}').join('/')),
          findsOneWidget,
        );
      }

      await tester.pumpWidget(const SizedBox.shrink());
      for (final notifier in allNotifiers) {
        expect(notifier.subscribed, isFalse);
        notifier.dispose();
      }
    });
  }

  for (final count in [2, 3]) {
    testWidgets('ChangeNotifierBuilder$count balances repeated notifiers',
        (tester) async {
      final sharedNotifier = _TrackedNotifier();
      final notifiers = List<_TrackedNotifier>.filled(count, sharedNotifier);
      final allNotifiers = [sharedNotifier];
      var buildCount = 0;

      Widget buildWidget() => Directionality(
            textDirection: TextDirection.ltr,
            child: _builderFor(notifiers, () {
              buildCount++;
              return Text(
                  notifiers.map((notifier) => '${notifier.value}').join('/'));
            }),
          );

      await tester.pumpWidget(buildWidget());
      for (var position = 0; position < count; position++) {
        final replacement = _TrackedNotifier();
        notifiers[position] = replacement;
        allNotifiers.add(replacement);
        await tester.pumpWidget(buildWidget());

        expect(sharedNotifier.subscribed, notifiers.contains(sharedNotifier));
        final buildsBeforeSharedNotification = buildCount;
        sharedNotifier.increment();
        await tester.pumpAndSettle();
        expect(
          buildCount,
          notifiers.contains(sharedNotifier)
              ? greaterThan(buildsBeforeSharedNotification)
              : buildsBeforeSharedNotification,
        );

        final buildsBeforeReplacementNotification = buildCount;
        replacement.increment();
        await tester.pumpAndSettle();
        expect(buildCount, greaterThan(buildsBeforeReplacementNotification));
      }

      final buildsAfterReplacement = buildCount;
      sharedNotifier.increment();
      await tester.pumpAndSettle();
      expect(buildCount, buildsAfterReplacement);

      await tester.pumpWidget(const SizedBox.shrink());
      for (final notifier in allNotifiers) {
        expect(notifier.subscribed, isFalse);
        notifier.dispose();
      }
    });
  }
}

class MyState extends ChangeNotifier {
  int _count = 0;
  void increment() {
    _count++;
    notifyListeners();
  }

  String get output => '$_count';
}

class MyState2 extends MyState {}

class MyState3 extends MyState {}
