package io.dartboard.dart_board_core_plugin

import androidx.annotation.NonNull
import io.dartboard.navapi.Api

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** DartBoardCorePlugin */
class DartBoardCorePlugin: FlutterPlugin {

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    DartBoardNav.api = Api.Nav(flutterPluginBinding.binaryMessenger)
  }



  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {

  }
}
