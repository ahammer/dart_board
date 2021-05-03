import 'package:dart_board/dart_board.dart';
import 'package:flutter/material.dart';

import 'example_extension.dart';

void main() {
  runApp(DartBoard(
    extensions: [ExampleExtension()],
    initialRoute: "/home",
  ));
}
