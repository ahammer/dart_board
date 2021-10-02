
import 'dart:async';

import 'package:flutter/services.dart';

class DartBoardCorePlugin {
  static const MethodChannel _channel = MethodChannel('dart_board_core_plugin');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
