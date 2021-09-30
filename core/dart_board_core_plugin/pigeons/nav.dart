import 'package:pigeon/pigeon.dart';

@FlutterApi()
abstract class Nav {
  /// Can use this to clear the stack and set a new entry point
  /// E.g DartBoardFlutterActivity will call this onCreate()
  void setNavRoot(String route);
}
