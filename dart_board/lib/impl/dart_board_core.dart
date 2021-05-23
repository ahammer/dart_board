import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';

import '../dart_board.dart';
import 'widgets/route_not_found.dart';

final Logger log = Logger('DartBoard');
GlobalKey<_DartBoardState> dartBoardKey = GlobalKey();

/// The Dart Board Kernel
///
/// It implements DartBoardCore from the interface
/// and handles the entry point to your app.
///
/// It'll enable support/integration of features
///
class DartBoard extends StatefulWidget {
  /// These are the features we'll load

  final List<DartBoardFeature>? features;

  /// Deny List in the format of
  /// "Yourfeature:Decoration"
  final Map<String, String> pageDecorationDenyList;
  final Route Function(RouteSettings settings, WidgetBuilder builder)
      routeBuilder;
  final Widget pageNotFoundWidget;
  final String initialRoute;

  DartBoard(
      {Key? key,
      this.features,
      this.pageNotFoundWidget = const RouteNotFound(),
      required this.initialRoute,
      this.pageDecorationDenyList = const {},
      this.routeBuilder = kCupertinoRouteResolver})
      : super(key: key);

  @override
  _DartBoardState createState() => _DartBoardState();
}

/// The Dart Board State
/// We unwrap the routes
/// We also unwrap the decorations
/// Then we build the MaterialApp()
class _DartBoardState extends State<DartBoard> implements DartBoardCore {
  @override
  late List<RouteDefinition> routes;

  // All Page Decorations
  late List<PageDecoration> pageDecorations;

  // All App Decorations
  late List<WidgetWithChildBuilder> appDecorations;

  // Deny list for decorations (e.g. "/route:decoration_name")
  late List<String> pageDecorationDenyList;

  // Allow list for page decorations (e.g. "/route:decoration_name")
  late List<String> pageDecorationAllowList;

  // Recognized page decorations with a allow list (e.g. "decoration_name")
  late Set<String> whitelistedPageDecorations;

  late List<DartBoardFeature> allFeatures;

  @override
  void initState() {
    super.initState();
    buildFeatures();

    /// Navigate to the initial route
    Timer.run(() {
      dartBoardNavKey.currentState!.pushNamed(widget.initialRoute);
    });
  }

  void buildFeatures() {
    allFeatures = buildDependencyList(widget.features!);

    /// We pull out Routes and PageDecorations from the route
    routes = allFeatures.fold(
        <RouteDefinition>[],
        (previousValue, element) =>
            <RouteDefinition>[...previousValue, ...element.routes]);

    pageDecorations = allFeatures.fold<List<PageDecoration>>(
        <PageDecoration>[],
        ((previousValue, element) =>
            <PageDecoration>[...previousValue, ...element.pageDecorations]));

    appDecorations = allFeatures.fold<List<WidgetWithChildBuilder>>(
        <WidgetWithChildBuilder>[],
        (previousValue, element) => <WidgetWithChildBuilder>[
              ...previousValue,
              ...element.appDecorations
            ]);

    pageDecorationDenyList = allFeatures.fold<List<String>>(
        <String>[],
        ((previousValue, element) =>
            <String>[...previousValue, ...element.pageDecorationDenyList]));

    pageDecorationAllowList = allFeatures.fold<List<String>>(
        <String>[],
        ((previousValue, element) =>
            <String>[...previousValue, ...element.pageDecorationAllowList]));
  }

  /// Simple build
  @override
  Widget build(BuildContext context) => Provider<DartBoardCore>(
        create: (ctx) => this,
        child: MaterialApp(
          home: Material(),
          key: dartBoardKey,
          navigatorKey: dartBoardNavKey,
          builder: (context, navigator) => appDecorations.reversed
              .fold(navigator!, (child, element) => element(context, child)),
          onGenerateRoute: onGenerateRoute,
        ),
      );

  /// Generates a route from the features
  /// If it can't find, it falls back to route not found
  ///
  /// It'll also wrap a route with any decorations
  Route onGenerateRoute(RouteSettings settings) {
    final definition = routes.firstWhere((it) => it.matches(settings),
        orElse: () => NamedRouteDefinition(
            builder: (ctx, _) => widget.pageNotFoundWidget, route: '/404'));
    if (definition.routeBuilder != null) {
      return definition.routeBuilder!(
          settings, (ctx) => buildPageRoute(ctx, settings, definition));
    }
    return widget.routeBuilder(
        settings, (ctx) => buildPageRoute(ctx, settings, definition));
  }

  @override
  Widget buildPageRoute(
          BuildContext context, RouteSettings settings, RouteDefinition route,
          {bool decorate = true}) =>
      ApplyPageDecorations(
          denylist: pageDecorationDenyList,
          decorations: pageDecorations
              .where((decoration) =>
                  decorate &&
                  !pageDecorationDenyList
                      .contains('${settings.name}:${decoration.name}'))
              .toList(),
          child: route.builder(settings, context));

  @override
  List<DartBoardFeature> get features => allFeatures;

  /// Walks the feature tree and registers
  List<DartBoardFeature> buildDependencyList(List<DartBoardFeature> features,
      {List<DartBoardFeature> result = const <DartBoardFeature>[]}) {
    features.forEach((element) {
      result = buildDependencyList(element.dependencies, result: result);
      if (!result.contains(element)) {
        result = [...result, element];
      }
    });
    return result;
  }

  @override
  Widget applyPageDecorations(Widget child) => ApplyPageDecorations(
        denylist: pageDecorationDenyList,
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
    required this.child,
    required this.decorations,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) => decorations.reversed
      .fold(child, (previousValue, element) => element(context, previousValue));
}

/// This class can apply the page decorations.
/// E.g. if you are navigating with a non-named route but want them.
class ApplyPageDecorations extends StatelessWidget {
  final Widget child;
  final List<PageDecoration>? decorations;
  final List<String>? denylist;

  final RouteSettings? settings;

  const ApplyPageDecorations({
    required this.child,
    required this.decorations,
    Key? key,
    this.settings,
    this.denylist = const [],
  }) : super(key: key);
  @override
  Widget build(BuildContext context) => decorations!.reversed.fold(
      child,
      (previousValue, pageDecoration) =>
          pageDecoration.decoration(context, previousValue));
}

/// Some Route Resolvers to use in your app
/// These are page transition animations

/// Material
Route kMaterialRouteResolver(RouteSettings settings, WidgetBuilder builder) =>
    MaterialPageRoute(builder: builder, settings: settings);

/// Cupertino
Route kCupertinoRouteResolver(RouteSettings settings, WidgetBuilder builder) =>
    CupertinoPageRoute(builder: builder, settings: settings);
