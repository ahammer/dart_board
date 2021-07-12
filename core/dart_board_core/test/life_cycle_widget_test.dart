import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_core/impl/widgets/life_cycle_widget.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('test the life cycle widget', (tester) async {
    var started = false;
    await tester.pumpWidget(LifeCycleWidget(
        preInit: () => started = true,
        dispose: (ctx) => started = false,
        child: Container()));
    await tester.pumpAndSettle();
    expect(started, equals(true));
    await tester.pumpWidget(Container());
    await tester.pumpAndSettle();
    expect(started, equals(false));
  });

  testWidgets('test the life cycle widget - all null', (tester) async {
    await tester.pumpWidget(
        LifeCycleWidget(child: MaterialApp(home: Card(child: Text('hello')))));
    await tester.pumpAndSettle();
    expect(find.text('hello'), findsOneWidget);
  });
}
