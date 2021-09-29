import android.content.Context
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.dart.DartExecutor.DartEntrypoint
import io.flutter.embedding.engine.dart.DartExecutor.DartEntrypoint.createDefault


object DartBoardEngineManager {
  lateinit var engine : FlutterEngine


    fun initialize(context : Context) {
        engine = FlutterEngine(context)
        engine.dartExecutor.executeDartEntrypoint(createDefault())
        FlutterEngineCache.getInstance().put("default", engine)

    }
}