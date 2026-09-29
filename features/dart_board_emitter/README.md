# dart_board_emitter

`dart_board_emitter` sends typed values between Dart Board features.

Add `DartBoardEmitter()` to `DartBoard.features` before using the top-level
helpers:

```dart
import 'package:dart_board_core/dart_board_core.dart';
import 'package:dart_board_emitter/dart_board_emitter.dart';
import 'package:flutter/material.dart';

void main() => runApp(DartBoard(
      features: [DartBoardEmitter()],
      initialPath: '/',
    ));
```

Register a receiver before emitting, then unregister it when it no longer needs
messages. Call these helpers after `DartBoard` has mounted, such as from a
widget callback:

```dart
class IntReceiver extends Receiver<int> {
  @override
  void receiver(int value) => debugPrint('Received $value');
}

void sendExample() {
  final receiver = IntReceiver();
  registerReceiver<int>(receiver);
  emit<int>(42); // IntReceiver receives 42.
  unregisterReceiver<int>(receiver);
}
```
