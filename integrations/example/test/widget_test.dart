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

    // This is a minimal test just to make sure it builds
    expect(find.byType(DartBoard), findsOneWidget);
  });
}
