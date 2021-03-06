import 'package:dart_board_core/impl/widgets/route_widget.dart';
import 'package:dart_board_core/interface/nav_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../dart_board_core.dart';

class DartBoardInformationParser extends RouteInformationParser<DartBoardPath> {
  final String initialPath;

  DartBoardInformationParser(this.initialPath);

  @override
  Future<DartBoardPath> parseRouteInformation(
          RouteInformation routeInformation) =>
      Future.sync(
          () => DartBoardPath(routeInformation.location ?? '/', initialPath));

  @override
  RouteInformation restoreRouteInformation(DartBoardPath configuration) =>
      RouteInformation(location: configuration.path);
}

class DartBoardNavigationDelegate extends RouterDelegate<DartBoardPath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<DartBoardPath>
    implements DartBoardNav {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  final List<DartBoardDecoration> appDecorations;
  final String initialPath;
  late final DartBoardPath initialDartBoardPath =
      DartBoardPath('/', initialPath, showAnimation: false);
  late List<DartBoardPath> navStack = [initialDartBoardPath];

  @override
  String get currentPath {
    return navStack.last.path;
  }

  DartBoardNavigationDelegate(
      {required this.navigatorKey,
      required this.appDecorations,
      required this.initialPath});

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
    navStack = [DartBoardPath('/', initialPath)];

    push(path.path, expanded: true);
  }

  void _addPath(DartBoardPath dartBoardPath) {
    navStack.removeWhere((element) => element.path == dartBoardPath.path);
    navStack.add(dartBoardPath);
  }

  @override
  void clearWhere(bool Function(DartBoardPath path) predicate) {
    navStack.removeWhere((path) => predicate(path) && path.path != '/');
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
    if (navStack.length > 1) {
      navStack.removeLast();
    }
    notifyListeners();
  }

  @override
  void replaceTop(String path) {
    if (navStack.length > 1) {
      navStack.removeLast();
    }
    push(path);
  }

  @override
  void push(String path, {bool expanded = false}) {
    if (expanded) {
      _pushExpandedPath(path);
    } else {
      _addPath(DartBoardPath(path, initialPath));
    }
    notifyListeners();
  }

  /// Push a path and it's parent paths
  /// e.g. /a/b/c -> [/a, /a/b, /a/b/c]
  void _pushExpandedPath(String path) {
    if (path == '/') return;
    if (path.isEmpty) return;

    final uri = Uri.parse(path);
    for (var i = 1; i <= uri.pathSegments.length; i++) {
      _addPath(
          DartBoardPath('/' + uri.pathSegments.take(i).join('/'), initialPath));
    }
    notifyListeners();
  }

  @override
  void appendPath(String path) {
    if (path == '/') return;
    if (navStack.isNotEmpty) {
      final last = navStack.last;
      _addPath(DartBoardPath(
          (last.path == '/' ? last.rootPath : last.path) + path, initialPath));
    }

    notifyListeners();
  }

  @override
  void replaceRoot(String? path) {
    navStack.clear();

    if (path == null) {
      navStack.add(initialDartBoardPath);
    } else {
      navStack.add(DartBoardPath(path, initialPath, showAnimation: false));
    }

    notifyListeners();
  }

  @override
  ChangeNotifier get changeNotifier => this;

  @override
  List<DartBoardPath> get stack => navStack;

  @override
  void pushDynamic(
      {required String dynamicPathName, required WidgetBuilder builder}) {
    /// Trim the leading / if used here
    /// We'll put it back when we put the
    /// private prefix e.g. /_ back on
    if (dynamicPathName.startsWith('/')) {
      dynamicPathName = dynamicPathName.substring(1);
    }

    _addPath(
        DartBoardPath('/_$dynamicPathName', initialPath, builder: builder));
    notifyListeners();
  }
}

class DartBoardPath {
  final String path;
  final String rootPath;
  final WidgetBuilder? builder;
  final bool showAnimation;

  DartBoardPath(this.path, this.rootPath,
      {this.builder, this.showAnimation = true});

  late final Page page = DartBoardPage(
      path: path,
      rootTarget: rootPath,
      builder: builder,
      showAnimation: showAnimation);
}

/// A page in our history
/// Every page needs a "path" that is unique in the history
///
class DartBoardPage extends Page {
  final String path;
  final String rootTarget;
  final bool showAnimation;
  final WidgetBuilder? builder;

  DartBoardPage(
      {required this.path,
      required this.rootTarget,
      this.builder,
      this.showAnimation = true})
      : super(key: ValueKey(path));

  @override
  Route createRoute(BuildContext context) {
    final settings =
        RouteSettings(name: path == '/' ? rootTarget : path, arguments: this);

    final routes =
        DartBoardCore.instance.routes.where((e) => e.matches(settings));

    if (routes.isNotEmpty) {
      final routeDef = routes.first;
      if (routeDef.routeBuilder != null) {
        return routeDef.routeBuilder!(
          settings,
          (builder != null)
              ? builder!
              : (context) => RouteWidget(path == '/' ? rootTarget : path),
        );
      }
    }

    if (!showAnimation) {
      return PageRouteBuilder(
          settings: this,
          pageBuilder: (context, animation1, animation2) => RouteWidget(
                path == '/' ? rootTarget : path,
                decorate: true,
              ),
          transitionDuration: Duration.zero);
    }

    return MaterialPageRoute(
      settings: this,
      builder: (builder != null)
          ? builder!
          : (context) => RouteWidget(
                path == '/' ? rootTarget : path,
                decorate: true,
              ),
    );
  }
}
