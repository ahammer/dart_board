package io.dartboard.dart_board_core_plugin;

import android.content.Context;
import android.content.Intent;

import androidx.annotation.NonNull;

import io.dartboard.navapi.Api;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** DartBoardCorePlugin */
public class DartBoardCorePlugin implements FlutterPlugin {



  public static final String PARAMETER_ROUTE = "ROUTE";

  private static Api.Nav _nav;

  /// Gets the Nav API if you'd like to call it from Native
  public static Api.Nav getNav() {
    return _nav;
  }

  public static void launchScreen(Context context, String route) {
    warmup(context.getApplicationContext());
    Intent intent = new Intent(context, DartBoardFlutterActivity.class);
    intent.putExtra(PARAMETER_ROUTE, route);
    context.startActivity(intent);
  }

  /// Call this from MainApplication if possible (to warm early)
  public static void warmup(Context context) {
    if (FlutterEngineCache.getInstance().contains("default")) return;

    FlutterEngine engine = new FlutterEngine(context);
    engine.getDartExecutor().executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault());
    FlutterEngineCache.getInstance().put("default", engine);
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    _nav = new Api.Nav(flutterPluginBinding.getBinaryMessenger());
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    // Do nothing
  }
}
