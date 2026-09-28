import 'dart:async';

import 'package:dart_board_widgets/widgets/widget_stream.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders stream events and cancels on dispose', (tester) async {
    var cancelCalls = 0;
    final stream = StreamController<Widget>(onCancel: () => cancelCalls++);
    await tester.pumpWidget(WidgetStream((_) => stream.stream));

    stream.add(const SizedBox(key: ValueKey('first')));
    await tester.pump();
    await tester.pump();
    expect(find.byKey(const ValueKey('first')), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    expect(stream.hasListener, isFalse);
    expect(cancelCalls, 1);

    stream.add(const SizedBox(key: ValueKey('after dispose')));
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.byKey(const ValueKey('after dispose')), findsNothing);
    expect(cancelCalls, 1);
  });

  testWidgets('reports stream errors and stops listening', (tester) async {
    final error = StateError('stream failed');
    var cancelCalls = 0;
    final stream = StreamController<Widget>(onCancel: () => cancelCalls++);
    final observedErrors = <Object>[];
    Future<void>? pumpWidget;
    runZonedGuarded(
      () => pumpWidget = tester.pumpWidget(WidgetStream((_) => stream.stream)),
      (error, _) => observedErrors.add(error),
    );
    await pumpWidget;

    stream.addError(error);
    stream.add(const SizedBox(key: ValueKey('after error')));
    await tester.pump();

    expect(observedErrors, hasLength(1));
    expect(observedErrors.single, same(error));
    expect(stream.hasListener, isFalse);
    expect(cancelCalls, 1);
    expect(find.byKey(const ValueKey('after error')), findsNothing);
  });
}
