package io.dartboard.dart_board_core_plugin_example;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;

import androidx.annotation.Nullable;

import io.dartboard.dart_board_core_plugin.DartBoardCorePlugin;


public class MainActivity extends Activity {
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main_activity);
        findViewById(R.id.button1).setOnClickListener(view -> {
            DartBoardCorePlugin.launchScreen(this, "/launches");
        });
        findViewById(R.id.button2).setOnClickListener(view -> {
            DartBoardCorePlugin.launchScreen(this, "/minesweep");
        });
    }
}
