import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_debug/debug_feature.dart';
import 'package:flutter/cupertino.dart';

/// Just loading the extansion and showing the route
///
/// It's better to work on this while connected to an integrated app right now
/// (saves a ton of time)
///
/// However, in the future we can provide mocks/etc to show the AB/Disable
/// features
void main() =>
    runApp(DartBoard(initialRoute: '/debug', features: [DebugFeature()]));
