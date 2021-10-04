import 'package:pigeon/pigeon.dart';

@FlutterApi()
abstract class SpaceX {
  /// Can use this to clear the stack and set a new entry point
  /// E.g DartBoardFlutterActivity will call this onCreate()
  @async
  List<LaunchDataNative> getLaunches();
}

class LaunchDataNative {
  String? missionName;
  String? siteName;
}
