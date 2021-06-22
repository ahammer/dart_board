import 'package:dart_board_core/impl/widgets/convertor_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('test Convertor widget', (tester) async {
    await tester.pumpWidget(Convertor<int, String>(
        convertor: intToString, builder: (ctx, val) {
          return MaterialApp(home:Text(val));
        }, input: 10));
    await tester.pumpAndSettle();
    expect(find.text('5'), findsOneWidget);
  });
}

/// We divide by 2 to make sure we are gettting the string and not casting another way
String intToString(int val) => '${val~/2}';
