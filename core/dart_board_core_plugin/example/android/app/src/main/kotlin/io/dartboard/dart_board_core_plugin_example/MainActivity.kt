package io.dartboard.dart_board_core_plugin_example

import android.app.Activity
import android.os.Bundle
import android.widget.Button
import io.dartboard.dart_board_core_plugin.DartBoardNav
import io.flutter.embedding.android.FlutterActivity

class MainActivity: Activity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.homepage)
        findViewById<Button>(R.id.launch_flutter_screen).setOnClickListener {
            DartBoardNav.launchRoute(this,"/home2");
        }
        findViewById<Button>(R.id.launch_flutter_screen_2).setOnClickListener {
            DartBoardNav.launchRoute(this,"/home3");
        }
    }

}
