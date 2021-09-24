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
    addPath(path);
    navStack.add(path);
  }

  void pushRoute(String route) {
    addPath(DartBoardPath(route));
    notifyListeners();
  }

  void addPath(DartBoardPath dartBoardPath) {
    navStack.removeWhere((element) => element.path == dartBoardPath.path);
    navStack.add(dartBoardPath);
  }
}

class DartBoardPath {
  final String path;

  DartBoardPath(this.path);

  DartBoardPath get up {
    final uri = Uri.parse(path);
    if (uri.pathSegments.length <= 1) {
      return DartBoardPath('/');
    }

    return DartBoardPath(
        '/' + uri.pathSegments.take(uri.pathSegments.length - 1).join('/'));
  }

  List<MaterialPage> get pages {
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

class Nav {
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
}
