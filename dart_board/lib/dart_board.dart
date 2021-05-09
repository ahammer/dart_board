import 'package:dart_board_interface/dart_board_core.dart';
import 'package:dart_board_interface/dart_board_extension.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';

import 'impl/widgets/route_not_found.dart';

final Logger log = Logger("DartBoard");
GlobalKey<_DartBoardState> dartBoardKey = GlobalKey();

/// The Dart Board Entry Point
///
/// Give it a 404 Widget
/// Give it Extensions
/// Give it the InitialRoute
///
/// The kernel is designed to stay simple
///
class DartBoard extends StatefulWidget {
  /// These are the extensions we'll load

  final List<DartBoardExtension> extensions;

  /// Blacklist in the format of
  /// "YourExtension:Decoration"
  final Map<String, String> pageDecorationBlacklist;

  final Widget pageNotFoundWidget;
  final String initialRoute;

  DartBoard(
      {Key key,
      this.extensions,
      this.pageNotFoundWidget = const RouteNotFound(),
      @required this.initialRoute,
      this.pageDecorationBlacklist = const {}})
      : super(key: key);

  @override
  _DartBoardState createState() => _DartBoardState();
}

/// The Dart Board State
/// We unwrap the routes
/// We also unwrap the decorations
/// Then we build the MaterialApp()
class _DartBoardState extends State<DartBoard> implements DartBoardCore {
  List<RouteDefinition> routes;
  List<PageDecoration> pageDecorations;
  List<WidgetWithChildBuilder> appDecorations;
  List<DartBoardExtension> get allExtensions {
    final result = <DartBoardExtension>[];
    addAllChildren(result, widget.extensions);
    return result;
  }

  @override
  void initState() {
    super.initState();

    /// We pull out Routes and PageDecorations from the route
    final extensions = allExtensions;
    log.info("Loading Extensions: $extensions");
    routes = extensions.fold(
        <RouteDefinition>[],
        (previousValue, element) =>
            <RouteDefinition>[...previousValue, ...element.routes]);

    pageDecorations = extensions.fold(
        <PageDecoration>[],
        (previousValue, element) =>
            <PageDecoration>[...previousValue, ...element.pageDecorations]);

    appDecorations = extensions.fold(
        <WidgetWithChildBuilder>[],
        (previousValue, element) => <WidgetWithChildBuilder>[
              ...previousValue,
              ...element.appDecorations
            ]);
  }

  /// Simple build
  @override
  Widget build(BuildContext context) => Provider<DartBoardCore>(
        create: (ctx) => this,
        child: MaterialApp(
          key: dartBoardKey,
          navigatorKey: dartBoardNavKey,
          initialRoute: widget.initialRoute,
          builder: (context, navigator) => appDecorations.reversed
              .fold(navigator, (child, element) => element(context, child)),
          onGenerateRoute: onGenerateRoute,
        ),
      );

  /// Generates a route from the extensions
  /// If it can't find, it falls back to route not found
  ///
  /// It'll also wrap a route with any decorations
  Route onGenerateRoute(RouteSettings settings) => MaterialPageRoute(
      settings: settings,
      builder: (ctx) => ApplyPageDecorations(
          decorations: pageDecorations,
          child: routes
              .firstWhere((it) => it.matches(settings),
                  orElse: () => NamedRouteDefinition(
                      builder: (ctx, _) => widget.pageNotFoundWidget,
                      route: '/404'))
              ?.builder(ctx, settings)));

  @override
  List<DartBoardExtension> get extensions => widget.extensions;

  /// Walks the Extension tree and registers
  void addAllChildren(
      List<DartBoardExtension> result, List<DartBoardExtension> extensions) {
    extensions.forEach((element) {
      addAllChildren(result, element.dependencies);
      if (!result.contains(element)) {
        result.add(element);
      }
    });
  }

  @override
  Widget applyPageDecorations(Widget child, {RouteSettings settings}) =>
      ApplyPageDecorations(
        decorations: pageDecorations,
        child: child,
      );
}

/// This class can apply the page decorations.
/// E.g. if you are navigating with a non-named route but want them.
class ApplyDecorations extends StatelessWidget {
  final Widget child;
  final List<WidgetWithChildBuilder> decorations;

  const ApplyDecorations({
    @required this.child,
    @required this.decorations,
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) => decorations.reversed
      .fold(child, (previousValue, element) => element(context, previousValue));
}

/// This class can apply the page decorations.
/// E.g. if you are navigating with a non-named route but want them.
class ApplyPageDecorations extends StatelessWidget {
  final Widget child;
  final List<PageDecoration> decorations;
  final RouteSettings settings;

  const ApplyPageDecorations({
    @required this.child,
    @required this.decorations,
    Key key,
    this.settings,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) => decorations.reversed.fold(
      child,
      (previousValue, element) => element.isValidForRoute(context)
          ? element.decoration(context, previousValue)
          : previousValue);
}
