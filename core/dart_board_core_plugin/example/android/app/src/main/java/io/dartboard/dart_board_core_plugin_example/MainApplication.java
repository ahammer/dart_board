package io.dartboard.dart_board_core_plugin_example;

import android.app.Application;

import io.dartboard.dart_board_core_plugin.DartBoardCorePlugin;

public class MainApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        DartBoardCorePlugin.warmup(this);
    }
}
