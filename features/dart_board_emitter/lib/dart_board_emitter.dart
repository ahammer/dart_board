import 'package:dart_board_core/dart_board_core.dart';
import 'package:flutter/material.dart';

class DartBoardEmitter extends DartBoardFeature {
  final Map<Type, Set<Receiver>> _receivers = {};
  final Map<Type, dynamic> _values = {};

  @override
  String get namespace => "Emitter";

  void emit<T>(T data) {
    _values[T] = data;

    _receivers[data.runtimeType]?.forEach((element) {
      element.receiver(data);
    });
  }

  void register<T>(Receiver<T> receiver, {bool useCache = false}) {
    _receivers.putIfAbsent(T, () => {}).add(receiver);
    if (useCache && _values.containsKey(T)) {
      receiver.receiver(_values[T]!);
    }
  }

  void unregister<T>(Receiver<T> receiver) => _receivers[T]?.remove(receiver);
}

class ReceiverWidget<T> extends StatefulWidget {
  final Widget Function(BuildContext context, T? data) builder;
  final bool useCache;

  const ReceiverWidget({
    Key? key,
    required this.builder,
    this.useCache = false,
  }) : super(key: key);

  @override
  State<ReceiverWidget<T>> createState() => _ReceiverWidgetState<T>();
}

/// Mix this into your State objects
/// T = type you are listening to
/// V = the Widget type
///
/// Implement Receive in your State
mixin ReceiverMixin<T, V extends StatefulWidget> on State<V>
    implements Receiver<T> {
  bool get useCache => false;
  @override
  void initState() {
    super.initState();
    registerReceiver<T>(this, useCache: useCache);
  }

  @override
  void dispose() {
    super.dispose();
    unregisterReceiver<T>(this);
  }

  @override
  Type get type => T;
}
//mixin SingleTickerProviderStateMixin<T extends StatefulWidget> on State<T> implements TickerProvider {

class _ReceiverWidgetState<T> extends State<ReceiverWidget<T>>
    with ReceiverMixin<T, ReceiverWidget<T>> {
  T? data;

  @override
  bool get useCache => widget.useCache;

  @override
  Widget build(BuildContext context) => widget.builder(
        context,
        data,
      );

  @override
  void receiver(T data) {
    setState(() {
      this.data = data;
    });
  }
}

abstract class Receiver<T> {
  Receiver();
  Type get type => T;
  void receiver(T data);
}

void emit<T>(T data) {
  final DartBoardEmitter? emitter =
      DartBoardCore.instance.findByName("Emitter") as DartBoardEmitter;
  if (emitter != null) {
    emitter.emit(data);
  }
}

void registerReceiver<T>(Receiver<T> receiver, {bool useCache = false}) {
  final DartBoardEmitter? emitter =
      DartBoardCore.instance.findByName("Emitter") as DartBoardEmitter;
  if (emitter != null) {
    emitter.register<T>(receiver, useCache: useCache);
  }
}

void unregisterReceiver<T>(Receiver<T> receiver) {
  final DartBoardEmitter? emitter =
      DartBoardCore.instance.findByName("Emitter") as DartBoardEmitter;
  if (emitter != null) {
    emitter.register<T>(receiver);
  }
}
