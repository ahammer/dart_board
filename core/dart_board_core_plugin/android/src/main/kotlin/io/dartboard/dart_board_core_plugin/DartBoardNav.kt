package io.dartboard.dart_board_core_plugin

import android.content.Context
import android.content.Intent

object DartBoardNav {
    fun launchRoute(context : Context, route : String) {
        context.startActivity(Intent(context, DartBoardFlutterActivity::class.java))
    }
}