package io.dartboard.dart_board_core_plugin;

import androidx.annotation.NonNull;

import io.dartboard.navapi.Api;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** DartBoardCorePlugin */
public class DartBoardCorePlugin implements FlutterPlugin {

  /// getter for safety
  public static Api.Nav getNav() {
    return _nav;
  }

  private static Api.Nav _nav;
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    _nav = new Api.Nav(flutterPluginBinding.getBinaryMessenger());
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    // Do nothing
  }
}
