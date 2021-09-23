
import 'package:dart_board_core/impl/widgets/route_widget.dart';
import 'package:flutter/material.dart';

import '../../dart_board.dart';

class DartBoardInformationParser extends RouteInformationParser<DartBoardPath> {
  @override
  Future<DartBoardPath> parseRouteInformation(
      RouteInformation routeInformation) {
    print(routeInformation.location);
    return Future.sync(() => DartBoardPath(routeInformation.location ?? '/'));
  }

  @override
  RouteInformation restoreRouteInformation(DartBoardPath configuration) {
    return RouteInformation(location: configuration.path);
  }
}

class DartBoardNavigationDelegate extends RouterDelegate<DartBoardPath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<DartBoardPath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final List<DartBoardDecoration> appDecorations;
  final String initialRoute;
  
  
  DartBoardPath? currentPath;

  DartBoardNavigationDelegate(
      {required this.navigatorKey, required this.appDecorations, required this.initialRoute});

  @override
  DartBoardPath? get currentConfiguration => currentPath;

  @override
  Widget build(BuildContext context) => appDecorations.reversed.fold(
      Navigator(
        key: navigatorKey,
        pages: [
          MaterialPage(
              key: ValueKey(initialRoute),
              child: RouteWidget(initialRoute)),
          if (currentPath != null && currentPath!.path != '/')
            ...currentPath!.pages
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          currentPath = currentPath?.up ?? DartBoardPath('/');
          // Update the list of pages by setting _selectedBook to null
          //   _selectedBook = null;
          notifyListeners();

          return true;
        },
      ),
      (child, element) => element.decoration(context, child));

  @override
  Future<void> setNewRoutePath(DartBoardPath path) async {
    currentPath = path;
  }

  void pushRoute(String route) {
    currentPath = DartBoardPath(route);
    notifyListeners();
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