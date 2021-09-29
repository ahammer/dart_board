package io.dartboard.dart_board_core_plugin_example

import android.app.Application

class MainApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        DartBoardEngineManager.initialize(this)
    }
}