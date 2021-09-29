import android.content.Context
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache

object DartBoardEngineManager {
  lateinit var engine : FlutterEngine


    fun initialize(context : Context) {
        engine = FlutterEngine(context)
        FlutterEngineCache.getInstance().put("default", engine)
        
    }
}