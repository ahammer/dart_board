import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dart_board_core_plugin/dart_board_core_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('dart_board_core_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await DartBoardCorePlugin.platformVersion, '42');
  });
}
