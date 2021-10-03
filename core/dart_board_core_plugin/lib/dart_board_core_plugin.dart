import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_core_plugin/nav_api.dart';
import 'package:flutter/material.dart';

class Add2AppFeature extends DartBoardFeature {
  @override
  String get namespace => "Add2App";

  @override
  List<DartBoardDecoration> get appDecorations => [
        DartBoardDecoration(
            name: 'Add2App',
            decoration: (ctx, child) => LifeCycleWidget(
                preInit: () => Nav.setup(NavApi()),
                key: const ValueKey("Add2App_LC"),
                child: child))
      ];
}

class NavApi extends Nav {
  @override
  void setNavRoot(String route) => DartBoardCore.nav.replaceRoot(route);
}
