import 'package:dart_board_core/impl/widgets/change_notifier_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Verifies the Change Notifier is listening
  testWidgets('test ChangeNotifierBuilder widget', (tester) async {
    final notifier = MyState();
    await tester.pumpWidget(MaterialApp(home:
       ChangeNotifierBuilder<MyState>(
        notifier: notifier,
        builder: (ctx, val) => Text(val.output),
      ),
    ));
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
