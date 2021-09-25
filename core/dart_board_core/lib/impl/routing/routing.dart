import 'package:dart_board_core/impl/widgets/route_widget.dart';
import 'package:flutter/material.dart';

import '../../dart_board.dart';

class DartBoardInformationParser extends RouteInformationParser<DartBoardPath> {
  @override
  Future<DartBoardPath> parseRouteInformation(
          RouteInformation routeInformation) =>
      Future.sync(() => DartBoardPath(routeInformation.location ?? '/'));

  @override
  RouteInformation restoreRouteInformation(DartBoardPath configuration) =>
      RouteInformation(location: configuration.path);
}

class DartBoardNavigationDelegate extends RouterDelegate<DartBoardPath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<DartBoardPath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final List<DartBoardDecoration> appDecorations;
  final String initialRoute;
  List<DartBoardPath> navStack = [];

  String get activeRoute {
    if (navStack.isEmpty) {
      return '/';
    } else {
      return navStack.last.path;
    }
  }

  DartBoardNavigationDelegate(
      {required this.navigatorKey,
      required this.appDecorations,
      required this.initialRoute});

  @override
  DartBoardPath? get currentConfiguration =>
      navStack.isNotEmpty ? navStack.last : null;

  @override
  Widget build(BuildContext context) => appDecorations.reversed.fold(
      Navigator(
        key: navigatorKey,
        pages: [
          MaterialPage(
              key: ValueKey(initialRoute), child: RouteWidget(initialRoute)),
          if (navStack.isNotEmpty)
            ...navStack.fold<List<MaterialPage>>(
                [],
                (previousValue, element) =>
                    [...previousValue, ...element.pages]),
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }

          if (navStack.isEmpty) {
            return false;
          }
          final currentPath = navStack.last;

          final up = currentPath.up;
          if (up.path == '/') {
            navStack.removeLast();
          } else {
            navStack
              ..removeLast()
              ..add(up);
          }

          notifyListeners();
          return true;
        },
      ),
      (child, element) => element.decoration(context, child));

  @override
  Future<void> setNewRoutePath(DartBoardPath path) async {
    if (path.path == '/') return;
    _addPath(path);
    navStack.add(path);
  }

  void _addPath(DartBoardPath dartBoardPath) {
    navStack.removeWhere((element) => element.path == dartBoardPath.path);
    navStack.add(dartBoardPath);
  }

  void clearWhere(bool Function(DartBoardPath path) predicate) {
    navStack.removeWhere((e) {
      final result = predicate(e);
      if (result) {
        print('removing ${e.path}');
      }
      return result;
    });
    notifyListeners();
  }

  void popUntil(bool Function(DartBoardPath path) predicate) {
    for (var i = navStack.length - 1; i >= 0; i--) {
      if (predicate(navStack[i])) break;
      navStack.removeAt(i);
    }
    notifyListeners();
  }

  void pop() {
    if (navStack.isNotEmpty) {
      navStack.removeLast();
    }
    notifyListeners();
  }

  void replaceTop(String route) {
    if (navStack.isNotEmpty) {
      navStack.removeLast();
    }
    pushRoute(route);
  }

  void pushRoute(String route) {
    if (route == '/') return;
    _addPath(DartBoardPath(route));
    notifyListeners();
  }
}

class DartBoardPath {
  final String path;
  late final List<MaterialPage> pages = _pages;

  DartBoardPath(this.path);

  DartBoardPath get up {
    final uri = Uri.parse(path);
    if (uri.pathSegments.length <= 1) {
      return DartBoardPath('/');
    }

    return DartBoardPath(
        '/' + uri.pathSegments.take(uri.pathSegments.length - 1).join('/'));
  }

  List<MaterialPage> get _pages {
    final uri = Uri.parse(path);
    final pages = <MaterialPage>[];

    for (var i = 0; i < uri.pathSegments.length; i++) {
      final currentPath = '/' + uri.pathSegments.take(i + 1).join('/');
      pages.add(MaterialPage(
          key: ValueKey(currentPath), child: RouteWidget(currentPath)));
    }
    return pages;
  }
}

/// Global navigation hooks
///
/// For the main router and access
class Nav {
  static ChangeNotifier get changeNotifier {
    final currentDelegate = DartBoardCore.instance.routerDelegate;
    if (currentDelegate is DartBoardNavigationDelegate) {
      return currentDelegate;
    }

    throw Error();
  }

  static List<DartBoardPath> get stack {
    final currentDelegate = DartBoardCore.instance.routerDelegate;
    if (currentDelegate is DartBoardNavigationDelegate) {
      return currentDelegate.navStack;
    }

    return [];
  }

  static String get currentRoute {
    final currentDelegate = DartBoardCore.instance.routerDelegate;
    if (currentDelegate is DartBoardNavigationDelegate) {
      return currentDelegate.activeRoute;
    }

    return '/';
  }

  static void pushRoute(String route) {
    final currentDelegate = DartBoardCore.instance.routerDelegate;
    if (currentDelegate is DartBoardNavigationDelegate) {
      currentDelegate.pushRoute(route);
    }
  }

  static void clearWhere(bool Function(DartBoardPath) predicate) {
    final currentDelegate = DartBoardCore.instance.routerDelegate;
    if (currentDelegate is DartBoardNavigationDelegate) {
      currentDelegate.clearWhere(predicate);
    }
  }

  static void replaceTop(String route) {
    final currentDelegate = DartBoardCore.instance.routerDelegate;
    if (currentDelegate is DartBoardNavigationDelegate) {
      currentDelegate.replaceTop(route);
    }
  }

  static void clear() {
    final currentDelegate = DartBoardCore.instance.routerDelegate;
    if (currentDelegate is DartBoardNavigationDelegate) {
      currentDelegate.clearWhere((e) => true);
    }
  }

  static void popUntil(bool Function(DartBoardPath) predicate) {
    final currentDelegate = DartBoardCore.instance.routerDelegate;
    if (currentDelegate is DartBoardNavigationDelegate) {
      currentDelegate.popUntil(predicate);
    }
  }

  static void pop() {
    final currentDelegate = DartBoardCore.instance.routerDelegate;
    if (currentDelegate is DartBoardNavigationDelegate) {
      currentDelegate.pop();
    }
  }
}
