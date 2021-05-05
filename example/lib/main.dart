import 'package:dart_board/dart_board.dart';
import 'package:dart_board/impl/debug/debug_route_extension.dart';
import 'package:dart_board_theme_extension/theme_extension.dart';
import 'package:flutter/material.dart';

import 'example_extension.dart';

/// This is the entry point, isn't it clean?
void main() {
  runApp(DartBoard(
    extensions: [ThemeExtension(), ExampleExtension(), DebugRouteExtension()],
    initialRoute: '/about',
  ));
}
