import 'package:dart_board_core/impl/routing/routing.dart';

abstract class DartBoardNav {
  void clearWhere(bool Function(DartBoardPath path) predicate);
  void popUntil(bool Function(DartBoardPath path) predicate);
  void pop();
  void replaceTop(String route);
  void push(String route, {bool expanded});

  void appendRoute(String route);
}
