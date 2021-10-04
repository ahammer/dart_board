package io.dartboard.dart_board_spacex_plugin;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;


/** DartBoardSpacexPlugin */
public class DartBoardSpacexPlugin implements FlutterPlugin {
  static public Api.SpaceX getApi() {
    return _api;
  }

  static private Api.SpaceX _api;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    _api = new Api.SpaceX(flutterPluginBinding.getBinaryMessenger());
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
  }
}
