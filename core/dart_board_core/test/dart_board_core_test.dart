import 'package:dart_board_core/dart_board.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Blank Run Test', (tester) async {
    await tester.pumpWidget(DartBoard(
      initialRoute: '/main',
      features: [],
    ));
  });
}
