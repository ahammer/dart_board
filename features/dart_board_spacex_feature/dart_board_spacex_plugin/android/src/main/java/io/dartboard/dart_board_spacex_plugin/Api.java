// Autogenerated from Pigeon (v1.0.7), do not edit directly.
// See also: https://pub.dev/packages/pigeon

package io.dartboard.dart_board_spacex_plugin;

import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.common.StandardMessageCodec;
import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;
import java.util.Arrays;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

/** Generated class from Pigeon. */
@SuppressWarnings({"unused", "unchecked", "CodeBlock2Expr", "RedundantSuppression"})
public class Api {

  /** Generated class from Pigeon that represents data sent in messages. */
  public static class LaunchDataNative {
    private String missionName;
    public String getMissionName() { return missionName; }
    public void setMissionName(String setterArg) { this.missionName = setterArg; }

    private String siteName;
    public String getSiteName() { return siteName; }
    public void setSiteName(String setterArg) { this.siteName = setterArg; }

    Map<String, Object> toMap() {
      Map<String, Object> toMapResult = new HashMap<>();
      toMapResult.put("missionName", missionName);
      toMapResult.put("siteName", siteName);
      return toMapResult;
    }
    static LaunchDataNative fromMap(Map<String, Object> map) {
      LaunchDataNative fromMapResult = new LaunchDataNative();
      Object missionName = map.get("missionName");
      fromMapResult.missionName = (String)missionName;
      Object siteName = map.get("siteName");
      fromMapResult.siteName = (String)siteName;
      return fromMapResult;
    }
  }
  private static class SpaceXCodec extends StandardMessageCodec {
    public static final SpaceXCodec INSTANCE = new SpaceXCodec();
    private SpaceXCodec() {}
    @Override
    protected Object readValueOfType(byte type, ByteBuffer buffer) {
      switch (type) {
        case (byte)128:         
          return LaunchDataNative.fromMap((Map<String, Object>) readValue(buffer));
        
        default:        
          return super.readValueOfType(type, buffer);
        
      }
    }
    @Override
    protected void writeValue(ByteArrayOutputStream stream, Object value)     {
      if (value instanceof LaunchDataNative) {
        stream.write(128);
        writeValue(stream, ((LaunchDataNative) value).toMap());
      } else 
{
        super.writeValue(stream, value);
      }
    }
  }

  /** Generated class from Pigeon that represents Flutter messages that can be called from Java.*/
  public static class SpaceX {
    private final BinaryMessenger binaryMessenger;
    public SpaceX(BinaryMessenger argBinaryMessenger){
      this.binaryMessenger = argBinaryMessenger;
    }
    public interface Reply<T> {
      void reply(T reply);
    }
    static MessageCodec<Object> getCodec() {
      return SpaceXCodec.INSTANCE;
    }

    public void getLaunches(Reply<List<LaunchDataNative>> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(binaryMessenger, "dev.flutter.pigeon.SpaceX.getLaunches", getCodec());
      channel.send(null, channelReply -> {
        @SuppressWarnings("ConstantConditions")
        List<LaunchDataNative> output = (List<LaunchDataNative>)channelReply;
        callback.reply(output);
      });
    }
  }
  private static Map<String, Object> wrapError(Throwable exception) {
    Map<String, Object> errorMap = new HashMap<>();
    errorMap.put("message", exception.toString());
    errorMap.put("code", exception.getClass().getSimpleName());
    errorMap.put("details", null);
    return errorMap;
  }
}
