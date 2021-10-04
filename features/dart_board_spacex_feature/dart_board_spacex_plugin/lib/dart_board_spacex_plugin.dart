
import 'dart:async';

import 'package:flutter/services.dart';

class DartBoardSpacexPlugin {
  static const MethodChannel _channel = MethodChannel('dart_board_spacex_plugin');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
