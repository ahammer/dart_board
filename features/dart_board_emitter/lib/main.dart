import 'package:dart_board_core/dart_board_core.dart';
import 'package:dart_board_emitter/dart_board_emitter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(DartBoard(
    initialPath: '/emitter_sample',
    features: [
      DartBoardEmitter(),
      EmitterSample(),
    ],
  ));
}

class EmitterSample extends DartBoardFeature {
  @override
  String get namespace => "Emitter Sample";

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: "/emitter_sample",
            builder: (ctx, settings) => const EmitterSampleWidget())
      ];
}

class EmitterSampleWidget extends StatefulWidget {
  const EmitterSampleWidget({Key? key}) : super(key: key);

  @override
  State<EmitterSampleWidget> createState() => _EmitterSampleWidgetState();
}

class _EmitterSampleWidgetState extends State<EmitterSampleWidget> {
  bool _showReceiver = false;
  @override
  Widget build(BuildContext context) => Material(
        child: Column(
          children: [
            MaterialButton(
              onPressed: () {
                emit(DateTime.now());
              },
              child: const Text("Emit Current Date"),
            ),
            if (!_showReceiver)
              MaterialButton(
                onPressed: () {
                  setState(() {
                    _showReceiver = true;
                  });
                },
                child: const Text("Show Receiver"),
              ),
            if (_showReceiver)
              ReceiverWidget<DateTime>(
                  builder: (ctx, val) => Text("Data ($val)")),
            if (_showReceiver)
              ReceiverWidget<DateTime>(
                  builder: (ctx, val) => Text("Data ($val)"), useCache: true)
          ],
        ),
      );
}
