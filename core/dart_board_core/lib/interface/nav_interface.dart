import 'package:dart_board_core/impl/routing/routing.dart';
import 'package:flutter/material.dart';

abstract class DartBoardNav {
  /// The currently active (foreground) route
  String get currentPath;

  /// Change Notifier to listen to changes in nav
  ChangeNotifier get changeNotifier;

  /// Get the current stack
  List<DartBoardPath> get stack;

  /// Push a route onto the stack
  /// expanded will push sub-paths (e.g. /a/b/c will push [/a, /a/b, /a/b/c])
  void push(String path, {bool expanded});

  /// Pop the top most route
  void pop();

  /// Pop routers until the predicate clears
  void popUntil(bool Function(DartBoardPath path) predicate);

  /// Clear all routes in the stack that match the predicate
  void clearWhere(bool Function(DartBoardPath path) predicate);

  /// Pop & Push (replace top of stack)
  /// Does not work on '/'
  void replaceTop(String path);

  /// Append to the current route (e.g. /b appended to /a = /a/b)
  void appendPath(String path);

  // Replace the Root (Entry Point)
  // Generally for Add2App
  void replaceRoot(String path);

  /// Push a route with a dynamic route name
  void pushDynamic(
      {required String dynamicPathName, required WidgetBuilder builder});
}
