import 'package:dart_board_bloc/dart_board_bloc.dart';
import 'package:dart_board_core/dart_board.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// An example Cubit runner
///
/// Enables the CubitFeature (Route + Cubit)
/// Sets the inital route to '/main'
void main() => runApp(DartBoard(
      features: [CubitExampleFeature()],
      initialRoute: '/main',
    ));

/// A simple example Cubit
///
/// State is only an int here
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
  void decrement() => emit(state - 1);
}

/// This feature exposes a route and a Cubit
class CubitExampleFeature extends DartBoardFeature {
  @override
  String get namespace => 'CubitExample';
  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
          route: '/main',
          builder: (ctx, settings) => CubitPage(),
        )
      ];

  @override
  List<DartBoardDecoration> get appDecorations =>
      [BlocDecoration((ctx) => CounterCubit())];
}

/// Cubit Page that shows a counter
class CubitPage extends StatelessWidget {
  const CubitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: BlocBuilder<CounterCubit, int>(
          builder: (ctx, state) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('count $state'),
                MaterialButton(
                    onPressed: () => ctx.read<CounterCubit>().increment(),
                    child: const Text('Increment')),
                MaterialButton(
                    onPressed: () => ctx.read<CounterCubit>().decrement(),
                    child: const Text('Decrement')),
              ],
            ),
          ),
        ),
      );
}
