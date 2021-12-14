import 'package:dart_board_core/dart_board_core.dart';
import 'package:flutter/material.dart';

class DartBoardEmitter extends DartBoardFeature {
  final Map<Type, Set<Receiver>> _receivers = {};

  @override
  String get namespace => "Emitter";

  void emit<T>(T data) {
    _receivers[data.runtimeType]?.forEach((element) {
      element.receiver(data);
    });
  }

  void register<T>(Receiver<T> receiver) {
    _receivers.putIfAbsent(T, () => {}).add(receiver);
  }

  void unregister<T>(Receiver<T> receiver) => _receivers[T]?.remove(receiver);
}

class ReceiverWidget<T> extends StatefulWidget {
  final Widget Function(BuildContext context, T? data) builder;
  const ReceiverWidget({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  State<ReceiverWidget<T>> createState() => _ReceiverWidgetState<T>();
}

class _ReceiverWidgetState<T> extends State<ReceiverWidget<T>>
    implements Receiver<T> {
  T? data;

  @override
  void initState() {
    super.initState();
    registerReceiver<T>(this);
  }

  @override
  void dispose() {
    super.dispose();
    unregisterReceiver<T>(this);
  }

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

  @override
  Type get type => T;
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

void registerReceiver<T>(Receiver<T> receiver) {
  final DartBoardEmitter? emitter =
      DartBoardCore.instance.findByName("Emitter") as DartBoardEmitter;
  if (emitter != null) {
    emitter.register<T>(receiver);
  }
}

void unregisterReceiver<T>(Receiver<T> receiver) {
  final DartBoardEmitter? emitter =
      DartBoardCore.instance.findByName("Emitter") as DartBoardEmitter;
  if (emitter != null) {
    emitter.register<T>(receiver);
  }
}
