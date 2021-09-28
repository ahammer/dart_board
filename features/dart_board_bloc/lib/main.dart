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

/// The events which `CounterBloc` will react to.
abstract class CounterEvent {}

/// Notifies bloc to increment state.
class Increment extends CounterEvent {
  final int amount;

  Increment(this.amount);
}

/// A `CounterBloc` which handles converting `CounterEvent`s into `int`s.
class CounterBloc extends Bloc<CounterEvent, int> {
  /// The initial state of the `CounterBloc` is 0.
  CounterBloc() : super(0) {
    /// When an `Increment` event is added,
    /// the current `state` of the bloc is accessed via the `state` property
    /// and a new state is emitted via `emit`.
    on<Increment>((event, emit) => emit(state + event.amount));
  }
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
  List<DartBoardDecoration> get appDecorations => [
        CubitDecoration((ctx) => CounterCubit()),
        BlocDecoration((ctx) => CounterBloc()),
      ];
}

/// Cubit Page that shows a counter
class CubitPage extends StatelessWidget {
  const CubitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BlocBuilder<CounterCubit, int>(
                builder: (ctx, state) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Text('Cubit:  $state'),
                    MaterialButton(
                        onPressed: () => ctx.read<CounterCubit>().increment(),
                        child: const Text('Increment')),
                    MaterialButton(
                        onPressed: () => ctx.read<CounterCubit>().decrement(),
                        child: const Text('Decrement')),
                  ],
                ),
              ),
               BlocBuilder<CounterBloc, int>(
                builder: (ctx, state) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Text('Bloc:  $state'),
                    MaterialButton(
                        onPressed: () => ctx.read<CounterBloc>().add(Increment(1)),
                        child: const Text('Increment')),
                    MaterialButton(
                        onPressed: () => ctx.read<CounterBloc>().add(Increment(-1)),
                        child: const Text('Decrement')),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
