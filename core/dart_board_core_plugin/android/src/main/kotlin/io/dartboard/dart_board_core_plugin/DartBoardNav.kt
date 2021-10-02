package io.dartboard.dart_board_core_plugin

import android.content.Context
import android.content.Intent
import io.dartboard.navapi.Api

const val kEntryPoint = "ENTRY_POINT"
object DartBoardNav {

    /// Should be initialized with the plugin at flutter start
    lateinit var api: Api.Nav;

    fun launchRoute(context : Context, route : String) {

        val intent = Intent(context, DartBoardFlutterActivity::class.java)
        intent.putExtra(kEntryPoint, route)
        context.startActivity(intent)
    }



}