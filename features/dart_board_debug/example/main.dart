import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_debug/debug_feature.dart';
import 'package:flutter/cupertino.dart';

/// Just loading the feature and showing the route
void main() =>
    runApp(DartBoard(initialPath: '/debug', features: [DebugFeature()]));
