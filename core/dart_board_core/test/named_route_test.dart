import 'package:dart_board_core/dart_board.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Test the NamedRoute class', (tester) async {
    final RouteDefinition def = NamedRouteDefinition(
        route: 'test',
        builder: (settings, ctx) =>
            MaterialApp(home: Material(child: Text('visible'))));
    await tester.pumpWidget(Builder(
        builder: (ctx) => def.builder(RouteSettings(name: 'test'), ctx)));
    await tester.pumpAndSettle();

    expect(def.matches(RouteSettings(name: 'test')), equals(true));
    expect(def.matches(RouteSettings(name: 'asdsadsa')), equals(false));
    expect(def.toString(), equals('test'));

    expect(find.text('visible'), findsOneWidget);
  });
}
