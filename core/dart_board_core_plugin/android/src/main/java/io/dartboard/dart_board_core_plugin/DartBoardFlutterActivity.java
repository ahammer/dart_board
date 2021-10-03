package io.dartboard.dart_board_core_plugin;

import android.os.Bundle;

import androidx.annotation.Nullable;

import io.flutter.embedding.android.FlutterActivity;

public class DartBoardFlutterActivity extends FlutterActivity {
    @Nullable
    @Override
    public String getCachedEngineId() {
        return "default";
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (savedInstanceState == null) {
            String route = getIntent().getStringExtra(DartBoardCorePlugin.PARAMETER_ROUTE);

            if (route == null)
                throw new IllegalArgumentException(DartBoardCorePlugin.PARAMETER_ROUTE + " EXTRA CAN NOT BE NULL");

            DartBoardCorePlugin.getNav().setNavRoot(route, null);
        }
    }
}
