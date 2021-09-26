import 'package:dart_board_core/impl/widgets/route_widget.dart';
import 'package:dart_board_core/interface/nav_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../dart_board.dart';

class DartBoardInformationParser extends RouteInformationParser<DartBoardPath> {
  final String initialRoute;

  DartBoardInformationParser(this.initialRoute);

  @override
  Future<DartBoardPath> parseRouteInformation(
          RouteInformation routeInformation) =>
      Future.sync(
          () => DartBoardPath(routeInformation.location ?? '/', initialRoute));

  @override
  RouteInformation restoreRouteInformation(DartBoardPath configuration) {
    print('restoring route information ${configuration.path}');
    return RouteInformation(location: configuration.path);
  }
}

class DartBoardNavigationDelegate extends RouterDelegate<DartBoardPath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<DartBoardPath>
    implements DartBoardNav {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final List<DartBoardDecoration> appDecorations;
  final String initialRoute;
  late final DartBoardPath initialDartBoardPath =
      DartBoardPath('/', initialRoute);
  late List<DartBoardPath> navStack = [initialDartBoardPath];

  @override
  String get currentRoute {
    return navStack.last.path;
  }

  DartBoardNavigationDelegate(
      {required this.navigatorKey,
      required this.appDecorations,
      required this.initialRoute});

  @override
  DartBoardPath? get currentConfiguration =>
      navStack.isNotEmpty ? navStack.last : null;

  @override
  Widget build(BuildContext context) {
    var list = navStack.map((e) => e.page).toList();

    return appDecorations.reversed.fold(
        Navigator(
          transitionDelegate: DefaultTransitionDelegate(),
          key: navigatorKey,
          pages: list,
          onPopPage: (route, result) {
            if (!route.didPop(result)) {
              return false;
            }

            if (navStack.isEmpty) {
              notifyListeners();
              return false;
            }
            navStack.removeLast();

            notifyListeners();
            return true;
          },
        ),
        (child, element) => element.decoration(context, child));
  }

  @override
  Future<void> setNewRoutePath(DartBoardPath path) async {
    navStack = [DartBoardPath('/', initialRoute)];

    push(path.path, expanded: true);
  }

  void _addPath(DartBoardPath dartBoardPath) {
    navStack.removeWhere((element) => element.path == dartBoardPath.path);
    navStack.add(dartBoardPath);
  }

  @override
  void clearWhere(bool Function(DartBoardPath path) predicate) {
    navStack.removeWhere((path) {
      final result = predicate(path) && path.path != '/';
      if (result) {
        print('removing ${path.path}');
      }
      return result;
    });
    notifyListeners();
  }

  @override
  void popUntil(bool Function(DartBoardPath path) predicate) {
    for (var i = navStack.length - 1; i >= 0; i--) {
      if (predicate(navStack[i])) break;
      navStack.removeAt(i);
    }
    notifyListeners();
  }

  @override
  void pop() {
    if (navStack.isNotEmpty) {
      navStack.removeLast();
    }
    notifyListeners();
  }

  @override
  void replaceTop(String route) {
    if (navStack.isNotEmpty) {
      navStack.removeLast();
    }
    push(route);
  }

  @override
  void push(String route, {bool expanded = false}) {
    if (expanded) {
      _pushExpandedPath(route);
    } else {
      _addPath(DartBoardPath(route, initialRoute));
    }
    notifyListeners();
  }

  /// Push a path and it's parent routes
  /// e.g. /a/b/c -> [/a, /a/b, /a/b/c]
  void _pushExpandedPath(String path) {
    if (path == '/') return;
    if (path.isEmpty) return;

    final uri = Uri.parse(path);
    for (var i = 1; i <= uri.pathSegments.length; i++) {
      _addPath(DartBoardPath(
          '/' + uri.pathSegments.take(i).join('/'), initialRoute));
    }
    notifyListeners();
  }

  @override
  void appendRoute(String route) {
    if (route == '/') return;
    if (navStack.isNotEmpty) {
      final last = navStack.last;
      _addPath(DartBoardPath(last.path + route, initialRoute));
    }

    notifyListeners();
  }

  @override
  ChangeNotifier get changeNotifier => this;

  @override
  List<DartBoardPath> get stack => navStack;
}

class DartBoardPath {
  final String path;
  final String initialRoute;

  DartBoardPath(this.path, this.initialRoute);

  late Page page = DartBoardPage(path: path, rootTarget: initialRoute);
}

/// A page in our history
/// Every page needs a "path" that is unique in the history
///
class DartBoardPage extends Page {
  final String path;
  final String rootTarget;

  DartBoardPage({required this.path, required this.rootTarget})
      : super(key: ValueKey(path));

  @override
  Route createRoute(BuildContext context) {
    final settings = RouteSettings(name: path == '/' ? rootTarget : path);

    final routeDef =
        DartBoardCore.instance.routes.where((e) => e.matches(settings)).first;

    if (routeDef.routeBuilder != null) {
      return routeDef.routeBuilder!(
        settings,
        (context) => RouteWidget(path == '/' ? rootTarget : path),
      );
    }

    return MaterialPageRoute(
      settings: this,
      builder: (context) => RouteWidget(
        path == '/' ? rootTarget : path,
        decorate: true,
      ),
    );
  }
}
