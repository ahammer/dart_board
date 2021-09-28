import 'package:dart_board_core/dart_board.dart';

/// Bloc Bindings for features
///
/// 1) Bloc repository (a single multibloc provider for your app)
/// 2) Decorations to add Blocs
///
/// Everything else will be standard
///

import 'package:dart_board_core/dart_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Simple Locator/DI/Service Injector for DartBoard
///
/// In your Features.
///
/// Register Factories in the AppDecorations
///   [LocatorDecoration(()=>YourType())];
///
/// Use YourType Anywhere
///
/// YourType obj = locate();
///
/// or
///
/// locate<YourType>()
///   ..width = 10
///   ..doSomethingElse()
///
///
/// Optionally, with instanceId
///
/// locate<YourType>(instance_id: "unique state id")
///
class DartBoardBlocFeature extends DartBoardFeature {
  final List<Cubit> cubits = [];

  registerCubit<T>(Cubit<T> cubit) {
    cubits.add(cubit);
  }

  @override
  String get namespace => "Bloc";
}

/// This decoration applies
class BlocDecoration<T> extends DartBoardDecoration {
  final Cubit<T> cubit;

  BlocDecoration(this.cubit)
      : super(
            name: "Loc${T.toString()}",
            decoration: (BuildContext context, Widget child) => LifeCycleWidget(
                key: ValueKey("LocatorDecoration_${T.toString()}"),
                preInit: () => (DartBoardCore.instance.findByName("Bloc")
                        as DartBoardBlocFeature)
                    .registerCubit<T>(cubit),
                child: Builder(builder: (ctx) => child)));
}
