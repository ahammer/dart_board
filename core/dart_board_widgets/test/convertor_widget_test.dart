import 'package:dart_board_widgets/widgets/convertor_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('test Convertor widget', (tester) async {
    final key = ValueKey('key');
    await tester.pumpWidget(Convertor<int, String>(
        key: key,
        convertor: intToString,
        builder: (ctx, val) {
          return MaterialApp(home: Text(val));
        },
        input: 10));
    await tester.pumpAndSettle();
    await tester.pumpWidget(Convertor<int, String>(
        key: key,
        convertor: intToString,
        builder: (ctx, val) {
          return MaterialApp(home: Text(val));
        },
        input: 20));

    expect(find.text('10'), findsOneWidget);
  });
}

/// We divide by 2 to make sure we are gettting the string and not casting another way
String intToString(int val) => '${val ~/ 2}';
