# dart_board_emitter

`dart_board_emitter` sends typed values between Dart Board features.

Add `DartBoardEmitter()` to your existing `DartBoard.features` list before
using the top-level helpers. Keep the feature that provides your initial route:

```dart
import 'package:dart_board_emitter/dart_board_emitter.dart';
import 'package:flutter/foundation.dart';

features: [DartBoardEmitter(), ...otherFeatures],
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

For widgets, `ReceiverWidget<T>` rebuilds when a message arrives, and
`ReceiverMixin<T, V>` subscribes a `State<V>` for its lifetime.
