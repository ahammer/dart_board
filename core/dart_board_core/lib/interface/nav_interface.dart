import 'package:dart_board_core/impl/routing/routing.dart';
import 'package:flutter/material.dart';

abstract class DartBoardNav {
  String get currentRoute;
  ChangeNotifier get changeNotifier;
  List<DartBoardPath> get stack;

  void clearWhere(bool Function(DartBoardPath path) predicate);
  void popUntil(bool Function(DartBoardPath path) predicate);
  void pop();
  void replaceTop(String route);
  void push(String route, {bool expanded});

  void appendRoute(String route);
}
