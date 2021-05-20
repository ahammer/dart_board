import 'package:dart_board/dart_board.dart';
import 'package:example/impl/routes/custom_routes.dart';
import 'package:flutter/material.dart';

import 'example_feature.dart';

/// This is the entry point, isn't it clean?
void main() {
  runApp(DartBoard(
    features: [Examplefeature()],
    initialRoute: '/home',
    pageRouteBuilder: kCustomRoute,
  ));
}
