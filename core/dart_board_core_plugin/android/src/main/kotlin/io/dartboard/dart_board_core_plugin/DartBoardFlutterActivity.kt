package io.dartboard.dart_board_core_plugin

import android.os.Bundle
import android.os.PersistableBundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngineCache

class DartBoardFlutterActivity : FlutterActivity() {
    override fun getCachedEngineId() = "default"

    override fun onCreate(savedInstanceState: Bundle?, persistentState: PersistableBundle?) {
        /// Navigate on flutter (set the root)
        DartBoardNav.api.setNavRoot(intent.getStringExtra(kEntryPoint)){}
        super.onCreate(savedInstanceState, persistentState)
    }
}