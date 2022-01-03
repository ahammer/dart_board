import 'package:dart_board_widgets/widgets/change_notifier_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
