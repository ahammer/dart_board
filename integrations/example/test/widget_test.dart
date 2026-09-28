// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:dart_board_core/dart_board_core.dart';
import 'package:example/example_feature.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App initialization test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(DartBoard(
      features: [ExampleFeature()],
      initialPath: '/main',
    ));

    // Advance the splash timers; particle animations intentionally never settle.
    await tester.pump(const Duration(seconds: 3));
    await tester.pump(const Duration(seconds: 3));

    await tester.pump(const Duration(milliseconds: 1));

    // Verify the app builds after startup completes.
    expect(find.byType(DartBoard), findsOneWidget);
    expect(find.text('Template'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });
}
