package io.dartboard.dart_board_spacex_plugin_example;

import android.os.Bundle;
import android.widget.Toast;

import androidx.annotation.Nullable;

import java.util.List;

import io.dartboard.dart_board_spacex_plugin.Api;
import io.dartboard.dart_board_spacex_plugin.DartBoardSpacexPlugin;
import io.flutter.embedding.android.FlutterActivity;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    protected void onResume() {
        super.onResume();
        DartBoardSpacexPlugin.getApi().getLaunches(reply -> {
            Toast.makeText(this, "Found Results"+reply.size(), Toast.LENGTH_LONG).show();
        });
    }
}
