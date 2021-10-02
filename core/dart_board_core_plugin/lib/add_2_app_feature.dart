import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_core_plugin/nav_api.dart';
import 'package:flutter/cupertino.dart';

class DartBoardAdd2AppFeature extends DartBoardFeature {
  final nav = _MyNav();

  @override
  String get namespace => "Add2App";

  @override
  List<DartBoardDecoration> get appDecorations => [
        DartBoardDecoration(
            name: 'Add2AppNavLifecycle',
            decoration: (ctx, child) => LifeCycleWidget(
                key: const ValueKey('Add2AppLifecycle'),
                preInit: () => Nav.setup(_MyNav()),
                child: child))
      ];
}

class _MyNav extends Nav {
  @override
  void setNavRoot(String route) => DartBoardCore.nav.replaceRoot(route);
}
