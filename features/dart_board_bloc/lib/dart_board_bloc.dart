import 'package:dart_board_core/dart_board.dart';

/// Bloc Bindings for features
///
/// Bloc doesn't require a Feature, but it can use Decoration bindings
/// This'll let you install blocs with other features that use it for state
/// management
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// This decoration adds a Cubit to the App
class CubitDecoration<T extends Cubit<V>, V> extends DartBoardDecoration {
  CubitDecoration(T Function(BuildContext) cubitBuilder)
      : super(
            name: "Cubit${T.toString()}",
            decoration: (BuildContext context, Widget child) =>
                BlocProvider<T>(create: cubitBuilder, child: child));
}

/// This decoration applies a Bloc to the App
class BlocDecoration<T extends Bloc, V> extends DartBoardDecoration {
  BlocDecoration(T Function(BuildContext) blocBuilder)
      : super(
            name: "Bloc${T.toString()}",
            decoration: (BuildContext context, Widget child) =>
                BlocProvider<T>(create: blocBuilder, child: child));
}
