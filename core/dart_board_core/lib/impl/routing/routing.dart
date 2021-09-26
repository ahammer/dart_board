import 'package:dart_board_core/impl/widgets/route_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../dart_board.dart';

class DartBoardInformationParser extends RouteInformationParser<DartBoardPath> {
  @override
  Future<DartBoardPath> parseRouteInformation(
          RouteInformation routeInformation) =>
      Future.sync(() => DartBoardPath(routeInformation.location ?? '/'));

  @override
  RouteInformation restoreRouteInformation(DartBoardPath configuration) {
    print('restoring route information ${configuration.path}');
    return RouteInformation(location: configuration.path);
  }
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

  late List<Page> pages;
  late final root = DartBoardPage(path: initialRoute);

  @override
  Widget build(BuildContext context) {
    pages = <Page>[
      root,
      if (navStack.isNotEmpty)
        ...navStack.fold<List<Page>>([],
            (previousValue, element) => [...previousValue, ...element.pages]),
    ];

    print('----------------- PAGES ---------------');
    for (final page in pages) {
      print('${(page.key as ValueKey).value}');
    }
    print('----------------- END PAGES ---------------');
    return appDecorations.reversed.fold(
        Navigator(
          transitionDelegate: DefaultTransitionDelegate(),
          key: navigatorKey,
          pages: pages,
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
  }

  @override
  Future<void> setNewRoutePath(DartBoardPath path) async {
    if (path.path == '/') {
      navStack.clear();
      notifyListeners();
      return;
    }
    _addPath(path);
  }

  void _addPath(DartBoardPath dartBoardPath) {
    /// Clear duplicates
    ///navStack.removeWhere((element) => element.path == dartBoardPath.path);

    /// Clear parent paths on stack (e.g. move to front)
    /// This is to prevent
    /// /path/cat
    /// /path/cat/b
    ///
    /// in the stack, which would go up through 5 pages instead of 3.
    /// e.g. b->cat->path->cat->path->root
    /// vs b->cat->path->root
    ///
    /// The same logic is in there for named routes, when pushed they are moved
    /// to the top
    var path = dartBoardPath.up;
    while (path.path != '/') {
      navStack.removeWhere((element) => element.path == dartBoardPath.path);
      path = path.up;
    }

    navStack
        .removeWhere((element) => element.path.startsWith(dartBoardPath.path));

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

  void appendRoute(String route) {
    if (route == '/') return;
    if (navStack.isNotEmpty) {
      final last = navStack.removeLast();
      _addPath(DartBoardPath(last.path + route));
    }

    notifyListeners();
  }
}

class DartBoardPath {
  final String path;

  DartBoardPath(this.path, {this.inherittedPages});

  DartBoardPath get up {
    final uri = Uri.parse(path);
    if (uri.pathSegments.length <= 1) {
      return DartBoardPath('/');
    }

    return DartBoardPath(
        '/' + uri.pathSegments.take(uri.pathSegments.length - 1).join('/'),
        inherittedPages: pages.take(pages.length - 1).toList());
  }

  List<Page>? inherittedPages;
  List<Page>? _pages;

  List<Page> get pages {
    if (_pages == null) {
      if (inherittedPages != null) {
        return inherittedPages!;
      }
      print('Generating pages for $hashCode');
      final uri = Uri.parse(path);
      _pages = <DartBoardPage>[];

      for (var i = 0; i < uri.pathSegments.length; i++) {
        final currentPath = '/' + uri.pathSegments.take(i + 1).join('/');
        _pages!.add(DartBoardPage(path: currentPath));
      }
    }
    return _pages!;
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

  static List<Page> get pages {
    final currentDelegate = DartBoardCore.instance.routerDelegate;
    if (currentDelegate is DartBoardNavigationDelegate) {
      return currentDelegate.pages;
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

  static void appendRoute(String path) {
    final currentDelegate = DartBoardCore.instance.routerDelegate;
    if (currentDelegate is DartBoardNavigationDelegate) {
      currentDelegate.appendRoute(path);
    }
  }
}

/// A page in our history
/// Every page needs a "path" that is unique in the history
///
class DartBoardPage extends Page {
  final String path;

  DartBoardPage({required this.path}) : super(key: ValueKey(path));

  @override
  Route createRoute(BuildContext context) {
    final settings = RouteSettings(name: path);

    final routeDef =
        DartBoardCore.instance.routes.where((e) => e.matches(settings)).first;

    if (routeDef.routeBuilder != null) {
      return routeDef.routeBuilder!(
        settings,
        (context) => RouteWidget(path),
      );
    }

    return MaterialPageRoute(
      settings: this,
      builder: (context) => RouteWidget(path),
    );
  }
}
