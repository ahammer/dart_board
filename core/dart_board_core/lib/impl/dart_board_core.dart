import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/services/message_codec.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';

import '../dart_board.dart';
import 'widgets/route_not_found.dart';

/// Some helpers
late final Logger log = Logger('DartBoard');
late final NavigatorState navigator = dartBoardNavKey.currentState!;
late final BuildContext navigatorContext = dartBoardNavKey.currentContext!;

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
  /// A list of features and their configuration's
  /// e.g. [FeatureA(config), FeatureB(config)]
  ///
  /// These features will all be loaded
  final List<DartBoardFeature> features;

  /// Deny List in the format of
  ///
  /// ["Yourfeature:Decoration"]
  ///
  /// When a Page Decoration hits a Route in the Deny List, it will be
  /// excluded.
  ///
  /// Typical use case is to omit a decoration from a screen. For example
  /// if you had a page decoration you wanted globally except on particular
  /// screens. E.g. the Log Page doesn't show the Log Border.
  final Map<String, String> pageDecorationDenyList;

  /// The "Route" builder. This is an over-ride for how page routing
  /// is handled internally
  ///
  /// E.g. Material/Cupertino or Custom page Routing
  /// constants
  ///  - `kMaterialPageRouteResolver`
  ///  - `kCupertinoPageRouteResolver`
  ///  are available as platform defaults.
  final Route Function(RouteSettings settings, WidgetBuilder builder)
      routeBuilder;

  /// pageNotFound widget builder is essentially the `404` builder
  /// Not required, but if you expect 404's maybe you want to
  /// implement this.
  ///
  /// A basic debug one is provided out of the box
  final WidgetBuilder pageNotFoundWidgetBuilder;

  /// The initial route, where you want your app entry point to be
  /// doesn't have to be "/", can be any registered route.
  final String initialRoute;

  final Map<String, String?>? featureOverrides;

  DartBoard(
      {Key? key,
      required this.features,
      this.pageNotFoundWidgetBuilder = _pageNoteFound,
      required this.initialRoute,
      this.featureOverrides,
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
class _DartBoardState extends State<DartBoard> with DartBoardCore {
  @override
  late List<RouteDefinition> routes;

  @override
  // All Page Decorations
  late List<DartBoardDecoration> pageDecorations;

  @override
  // All App Decorations
  late List<DartBoardDecoration> appDecorations;

  @override
  late Map<String, MethodCallHandler> methodHandlers;

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
  List<DartBoardFeature> allFeatures = <DartBoardFeature>[];

  @override
  late Map<String, List<String>> detectedImplementations;

  @override
  final Map<String, String> activeImplementations = {};

  @override
  final Set<DartBoardFeature> loadedFeatures = <DartBoardFeature>{};

  late Map<String, String?> featureOverrides;

  bool _init = false;

  @override
  void initState() {
    super.initState();
    featureOverrides = widget.featureOverrides ?? {};
    buildFeatures();
    WidgetsBinding.instance
        ?.scheduleFrameCallback((timeStamp) => setState(() => _init = true));
  }

  /// Build Dart-Board Core
  ///
  /// 1) First we Provide DartBoardCore to the tree
  /// 2) Then provide a MaterialApp + Customizations
  ///
  @override
  Widget build(BuildContext context) => Provider<DartBoardCore>(
        create: (ctx) => this,
        child: MaterialApp(
          home: _init
              ? RouteWidget(
                  widget.initialRoute,
                  decorate: true,
                )
              : CircularProgressIndicator(),
          key: dartBoardKey,
          navigatorKey: dartBoardNavKey,
          builder: (context, navigator) => appDecorations.reversed.fold(
            navigator!,
            (child, element) => element.decoration(context, child),
          ),
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
          child: route.builder(context, settings));

  /// buildFeatures()
  ///
  /// This collects all the features into
  /// formats we can use.
  ///
  /// Usually run at init()
  /// If the features change, this can be rebuilt
  void buildFeatures() {
    setState(() {
      /// Grab from a cache
      final cachedFeatures = [...loadedFeatures];
      loadedFeatures.clear();
      detectedImplementations = {};
      final dependencies = buildDependencyList(widget.features);

      log.info('Bulding features');

      /// Lets keep the old features and check if we can restore instead of rebuild
      allFeatures = <DartBoardFeature>[];

      dependencies.forEach((element) {
        /// Pull from cache if possible
        final fromCache = cachedFeatures
            .where((cached) =>
                element.namespace == cached.namespace &&
                element.implementationName == cached.implementationName)
            .toList();

        if (fromCache.length == 1) {
          element = fromCache[0];
        }

        if (!detectedImplementations.containsKey(element.namespace)) {
          detectedImplementations[element.namespace] = [
            element.implementationName
          ];
        } else {
          //log.info('Detected duplicated extension ${element.namespace}');
          detectedImplementations[element.namespace]
              ?.add(element.implementationName);
        }

        if ((!loadedFeatures.contains(element) &&
                !(featureOverrides.containsKey(element.namespace)) ||
            (featureOverrides.containsKey(element.namespace) &&
                featureOverrides[element.namespace] ==
                    element.implementationName))) {
          loadedFeatures.add(element);
          allFeatures.add(element);
          log.info(
              'Loaded: ${element.implementationName} AKA "${element.namespace}"');
        } else if (!loadedFeatures.contains(element) &&
            featureOverrides[element.namespace] == null) {
          /// "Disabled" install stab instead
          log.info('Disabled: ${element.namespace} disabled, getting stubbed');
          final feat = StubFeature(element.namespace);
          allFeatures.add(feat);
          loadedFeatures.add(element);
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
                    .where((decoration) => decoration.enabled)
              ]));

      log.info('Available Page Decorations: $pageDecorations');

      /// Build up app decoration list
      appDecorations = allFeatures.fold<List<DartBoardDecoration>>(
          <DartBoardDecoration>[],
          (previousValue, element) => <DartBoardDecoration>[
                ...previousValue,
                ...element.appDecorations
                    .where((decoration) => decoration.enabled)
              ]);

      /// Build up the MethodHandler list. First takes priority.
      methodHandlers = allFeatures.fold<Map<String, MethodCallHandler>>(
          <String, MethodCallHandler>{},
          (previousValue, element) => <String, MethodCallHandler>{}
            ..addAll(element.methodHandlers)
            ..addAll(previousValue));

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
            builder: (ctx, settings) => widget.pageNotFoundWidgetBuilder(ctx),
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
    features.forEach((feature) {
      result = buildDependencyList(feature.dependencies, result: result);
      if (!result.contains(feature)) {
        result = [
          ...result,

          /// If the feature is enabled
          /// And we don't already see it in the list for the same namespace
          /// Since a dep can come from multiple sources, we just want the first
          ///
          if (feature.enabled &&
              result
                  .where((element) =>
                      element.namespace == feature.namespace &&
                      element.implementationName == feature.implementationName)
                  .isEmpty)
            feature
        ];
      }
    });
    return result;
  }

  @override
  void setFeatureImplementation(String namespace, String? value) =>
      setState(() {
        featureOverrides[namespace] = value;
        buildFeatures();
      });

  @override
  bool confirmRouteExists(String route) => routes.fold(
      false,
      (previousValue, element) =>
          previousValue || element.matches(RouteSettings(name: route)));

  @override
  bool isFeatureActive(String namespace) {
    if (featureOverrides.containsKey(namespace) &&
        featureOverrides[namespace] == null) {
      //Explicitly Disabled
      return false;
    }

    final count =
        allFeatures.where((element) => element.namespace == namespace).length;

    if (count == 0) {
      /// Not detected
      return false;
    }

    return true;
  }

  @override
  Future<dynamic> dispatchMethodCall(
      {required BuildContext context, required MethodCall call}) async {
    if (methodHandlers.containsKey(call.method) &&
        methodHandlers[call.method] != null) {
      return await methodHandlers[call.method]!(context, call);
    }

    throw Exception(
        'You attempted to call ${call.method} but it is not registered to an active feature');
  }
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
