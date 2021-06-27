import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';

import '../dart_board.dart';
import 'widgets/route_not_found.dart';

final Logger log = Logger('DartBoard');
GlobalKey<_DartBoardState> dartBoardKey = GlobalKey();

Widget _pageNoteFound(BuildContext context) =>
    RouteNotFound(ModalRoute.of(context)!.settings.name!);

/// The Dart Board Kernel
///
/// It implements DartBoardCore from the interface
/// and handles the entry point to your app.
///
/// It'll enable support/integration of features
///
class DartBoard extends StatefulWidget {
  /// These are the features we'll load

  final List<DartBoardFeature> features;

  /// Deny List in the format of
  /// "Yourfeature:Decoration"
  final Map<String, String> pageDecorationDenyList;
  final Route Function(RouteSettings settings, WidgetBuilder builder)
      routeBuilder;
  final WidgetBuilder pageNotFoundWidget;
  final String initialRoute;

  DartBoard(
      {Key? key,
      required this.features,
      this.pageNotFoundWidget = _pageNoteFound,
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

  @override
  // All Page Decorations
  late List<DartBoardDecoration> pageDecorations;

  @override
  // All App Decorations
  late List<DartBoardDecoration> appDecorations;

  @override
  // Deny list for decorations (e.g. "/route:decoration_name")
  late List<String> pageDecorationDenyList;

  @override
  // Allow list for page decorations (e.g. "/route:decoration_name")
  late List<String> pageDecorationAllowList;

  @override
  // Recognized page decorations with a allow list (e.g. "decoration_name")
  late Set<String> whitelistedPageDecorations;

  @override
  late List<DartBoardFeature> allFeatures;

  @override
  late Map<String, List<String>> detectedImplementations;

  @override
  Map<String, String> activeImplementations = {};

  Map<String, String?> featureOverrides = {};

  bool _init = false;

  @override
  void initState() {
    super.initState();
    buildFeatures();
    WidgetsBinding.instance
        ?.scheduleFrameCallback((timeStamp) => setState(() => _init = true));
  }

  /// Simple build
  @override
  Widget build(BuildContext context) => Provider<DartBoardCore>(
        create: (ctx) => this,
        child: MaterialApp(
          home: _init
              ? applyPageDecorations(RouteWidget(widget.initialRoute))
              : CircularProgressIndicator(),
          key: dartBoardKey,
          navigatorKey: dartBoardNavKey,
          builder: (context, navigator) => appDecorations.reversed.fold(
              navigator!,
              (child, element) => element.decoration(context, child)),
          onGenerateRoute: onGenerateRoute,
        ),
      );

  /// Dart Board Core Overrides
  @override
  Widget buildPageRoute(
          BuildContext context, RouteSettings settings, RouteDefinition route,
          {bool decorate = true}) =>
      ApplyPageDecorations(
          decorations: pageDecorations
              .where((decoration) =>
                  decorate &&
                  ((!whitelistedPageDecorations.contains(decoration.name) &&
                          !pageDecorationDenyList.contains(
                              '${settings.name}:${decoration.name}')) ||
                      ((whitelistedPageDecorations.contains(decoration.name) &&
                          pageDecorationAllowList.contains(
                              '${settings.name}:${decoration.name}')))))
              .toList(),
          child: route.builder(settings, context));

  /// buildFeatures()
  ///
  /// This collects all the features into
  /// formats we can use.
  ///
  /// Usually run at init()
  /// If the features change, this can be rebuilt
  void buildFeatures() {
    setState(() {
      var loadedFeatures = <String>{};
      detectedImplementations = {};
      final dependencies = buildDependencyList(widget.features);

      log.info('Bulding features');
      allFeatures = <DartBoardFeature>[];

      dependencies.forEach((element) {
        if (!detectedImplementations.containsKey(element.namespace)) {
          detectedImplementations[element.namespace] = [
            element.implementationName
          ];
        } else {
          //log.info('Detected duplicated extension ${element.namespace}');
          detectedImplementations[element.namespace]
              ?.add(element.implementationName);
        }

        if ((!loadedFeatures.contains(element.namespace) &&
                !(featureOverrides.containsKey(element.namespace)) ||
            (featureOverrides.containsKey(element.namespace) &&
                featureOverrides[element.namespace] ==
                    element.implementationName))) {
          loadedFeatures.add(element.namespace);
          allFeatures.add(element);
          log.info(
              'Loaded: ${element.implementationName} AKA "${element.namespace}"');
        } else if (!loadedFeatures.contains(element.namespace) &&
            featureOverrides[element.namespace] == null) {
          /// "Disabled" install stab instead
          log.info('Disabled: ${element.namespace} disabled, getting stubbed');
          final feat = StubFeature(element.namespace);
          allFeatures.add(feat);
          loadedFeatures.add(element.namespace);
        }
      });

      /// We pull out Routes and PageDecorations from the route
      routes = allFeatures.fold(
          <RouteDefinition>[],
          (previousValue, element) =>
              <RouteDefinition>[...previousValue, ...element.routes]);

      log.info('Available Routes: $routes');

      pageDecorations = allFeatures.fold<List<DartBoardDecoration>>(
          <DartBoardDecoration>[],
          ((previousValue, element) => <DartBoardDecoration>[
                ...previousValue,
                ...element.pageDecorations
              ]));

      log.info('Available Page Decorations: $pageDecorations');

      appDecorations = allFeatures.fold<List<DartBoardDecoration>>(
          <DartBoardDecoration>[],
          (previousValue, element) => <DartBoardDecoration>[
                ...previousValue,
                ...element.appDecorations
              ]);

      log.info('Available App Decorations: $appDecorations');

      pageDecorationDenyList = allFeatures.fold<List<String>>(
          <String>[],
          ((previousValue, element) =>
              <String>[...previousValue, ...element.pageDecorationDenyList]));
      log.info('Deny List: $pageDecorationDenyList');
      pageDecorationAllowList = allFeatures.fold<List<String>>(
          <String>[],
          ((previousValue, element) =>
              <String>[...previousValue, ...element.pageDecorationAllowList]));
      log.info('Allow List: $pageDecorationAllowList');
      whitelistedPageDecorations =
          pageDecorationAllowList.map((e) => e.split(':')[1]).toSet();

      /// register the selected implementation for each
      activeImplementations.clear();
      allFeatures.forEach((element) {
        if (!(element is StubFeature)) {
          activeImplementations[element.namespace] = element.implementationName;
        }
      });
    });
  }

  /// Generates a route from the features
  /// If it can't find, it falls back to route not found
  ///
  /// It'll also wrap a route with any decorations
  Route onGenerateRoute(RouteSettings settings) {
    final definition = routes.firstWhere((it) => it.matches(settings),
        orElse: () => NamedRouteDefinition(
            builder: (settings, ctx) => widget.pageNotFoundWidget(ctx),
            route: '/404'));
    if (definition.routeBuilder != null) {
      return definition.routeBuilder!(
          settings, (ctx) => buildPageRoute(ctx, settings, definition));
    }
    return widget.routeBuilder(
        settings, (ctx) => buildPageRoute(ctx, settings, definition));
  }

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
        decorations: pageDecorations,
        child: child,
      );

  @override
  void setFeatureImplementation(String namespace, String? value) =>
      setState(() {
        featureOverrides[namespace] = value;
        buildFeatures();
      });

  @override
  bool confirmRouteExists(String route) {
    return routes.fold(
        false,
        (previousValue, element) =>
            previousValue || element.matches(RouteSettings(name: route)));
  }
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
  final List<DartBoardDecoration>? decorations;
  final RouteSettings? settings;

  const ApplyPageDecorations({
    required this.child,
    required this.decorations,
    Key? key,
    this.settings,
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

class StubFeature extends DartBoardFeature {
  @override
  final String namespace;

  StubFeature(this.namespace);
}
