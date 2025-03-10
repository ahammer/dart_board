import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/services/message_codec.dart';
import 'package:logging/logging.dart';

import '../dart_board_core.dart';
import 'widgets/route_not_found.dart';

/// Some helpers
late final Logger log = Logger('DartBoard');
final Logger _initLog = Logger('DartBoard.Initialization');
late final NavigatorState navigator = dartBoardNavKey.currentState!;
late final BuildContext navigatorContext = dartBoardNavKey.currentContext!;

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
  final Route Function(RouteSettings settings, WidgetBuilder builder)?
      routeBuilder;

  /// pageNotFound widget builder is essentially the `404` builder
  /// Not required, but if you expect 404's maybe you want to
  /// implement this.
  ///
  /// A basic debug one is provided out of the box
  final WidgetBuilder pageNotFoundWidgetBuilder;

  /// The initial route, where you want your app entry point to be
  /// doesn't have to be "/", can be any registered route.
  final String initialPath;

  final Map<String, String?>? featureOverrides;

  final bool debugShowCheckedModeBanner;

  final bool debugShowMaterialGrid;

  final bool showSemanticDebugger;

  final bool checkberboardOffscreenLayers;

  final ThemeData? theme;

  final ThemeData? darkTheme;

  final ThemeMode? themeMode;

  DartBoard(
      {Key? key,
      required this.features,
      this.pageNotFoundWidgetBuilder = _pageNoteFound,
      required this.initialPath,
      this.featureOverrides,
      this.pageDecorationDenyList = const {},
      this.routeBuilder = null,
      this.debugShowCheckedModeBanner = false,
      this.debugShowMaterialGrid = false,
      this.showSemanticDebugger = false,
      this.checkberboardOffscreenLayers = false,
      this.theme,
      this.darkTheme,
      this.themeMode})
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

  late final dartBoardInformationParser =
      DartBoardInformationParser(widget.initialPath);
  late final dartBoardRouterDelegate = DartBoardNavigationDelegate(
      navigatorKey: dartBoardNavKey,
      appDecorations: appDecorations,
      initialPath: widget.initialPath);

  /// Expose the router Delegate for "nav" to work, or for your own nav if necessary
  ///
  @override
  RouterDelegate get routerDelegate => dartBoardRouterDelegate;

  @override
  void initState() {
    super.initState();
    initCore();
    featureOverrides = widget.featureOverrides ?? {};
    buildFeatures();
  }

  /// Build Dart-Board Core
  ///
  /// 1) First we Provide DartBoardCore to the tree
  /// 2) Then provide a MaterialApp + Customizations
  ///
  @override
  Widget build(BuildContext context) => MaterialApp.router(
      debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
      debugShowMaterialGrid: widget.debugShowMaterialGrid,
      showSemanticsDebugger: widget.showSemanticDebugger,
      checkerboardOffscreenLayers: widget.checkberboardOffscreenLayers,
      theme: widget.theme,
      darkTheme: widget.darkTheme,
      themeMode: widget.themeMode,
      routeInformationParser: dartBoardInformationParser,
      routerDelegate: dartBoardRouterDelegate);

  /*
  MaterialApp(
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
      );
      */

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
    _initLog.info('Starting feature build process');
    setState(() {
      /// Grab from a cache
      final cachedFeatures = [...loadedFeatures];
      loadedFeatures.clear();
      detectedImplementations = {};
      
      _initLog.info('Resolving dependency graph');
      final dependencies = buildDependencyList(widget.features);
      _initLog.info('Resolved ${dependencies.length} features in dependency order');

      /// Lets keep the old features and check if we can restore instead of rebuild
      allFeatures = <DartBoardFeature>[];

      _initLog.info('Processing features in dependency order');
      for (var i = 0; i < dependencies.length; i++) {
        var element = dependencies[i];
        _initLog.fine('Processing feature ${i+1}/${dependencies.length}: ${element.namespace}:${element.implementationName}');
        
        /// Pull from cache if possible
        final fromCache = cachedFeatures
            .where((cached) =>
                element.namespace == cached.namespace &&
                element.implementationName == cached.implementationName)
            .toList();

        if (fromCache.length == 1) {
          _initLog.fine('Restoring ${element.namespace}:${element.implementationName} from cache');
          element = fromCache[0];
        }

        if (!detectedImplementations.containsKey(element.namespace)) {
          detectedImplementations[element.namespace] = [
            element.implementationName
          ];
        } else {
          _initLog.info('Detected multiple implementations for ${element.namespace}: adding ${element.implementationName}');
          detectedImplementations[element.namespace]
              ?.add(element.implementationName);
        }

        bool shouldLoadFeature = false;
        
        // Determine if we should load this feature implementation
        if (!loadedFeatures.contains(element)) {
          if (!featureOverrides.containsKey(element.namespace)) {
            // No override, load the first implementation encountered
            shouldLoadFeature = true;
            _initLog.info('Loading ${element.namespace}:${element.implementationName} (no override)');
          } else if (featureOverrides[element.namespace] == element.implementationName) {
            // Explicit override matches this implementation
            shouldLoadFeature = true;
            _initLog.info('Loading ${element.namespace}:${element.implementationName} (explicit override)');
          } else if (featureOverrides[element.namespace] == null) {
            // Feature explicitly disabled
            _initLog.info('Feature ${element.namespace} explicitly disabled, stubbing');
            final feat = StubFeature(element.namespace);
            allFeatures.add(feat);
            loadedFeatures.add(element);
          } else {
            // Override exists but doesn't match this implementation
            _initLog.fine('Skipping ${element.namespace}:${element.implementationName} ' +
                'due to override for ${featureOverrides[element.namespace]}');
          }
        } else {
          _initLog.fine('Feature ${element.namespace}:${element.implementationName} already loaded');
        }
        
        if (shouldLoadFeature) {
          loadedFeatures.add(element);
          allFeatures.add(element);
        }
      }
      
      _initLog.info('Collecting routes from ${allFeatures.length} features');
      routes = allFeatures.fold(
          <RouteDefinition>[],
          (previousValue, element) {
            final featureRoutes = element.routes;
            _initLog.fine('Feature ${element.namespace}:${element.implementationName} provides ${featureRoutes.length} routes');
            return <RouteDefinition>[...previousValue, ...featureRoutes];
          });

      _initLog.info('Collected ${routes.length} total routes');

      _initLog.info('Collecting page decorations');
      pageDecorations = allFeatures.fold<List<DartBoardDecoration>>(
          <DartBoardDecoration>[],
          ((previousValue, element) {
            final decorations = element.pageDecorations.where((decoration) => decoration.enabled).toList();
            _initLog.fine('Feature ${element.namespace}:${element.implementationName} provides ${decorations.length} page decorations');
            return <DartBoardDecoration>[...previousValue, ...decorations];
          }));

      _initLog.info('Collected ${pageDecorations.length} total page decorations');

      /// Build up app decoration list
      _initLog.info('Collecting app decorations');
      appDecorations = allFeatures.fold<List<DartBoardDecoration>>(
          <DartBoardDecoration>[],
          (previousValue, element) {
            final decorations = element.appDecorations.where((decoration) => decoration.enabled).toList();
            _initLog.fine('Feature ${element.namespace}:${element.implementationName} provides ${decorations.length} app decorations');
            return <DartBoardDecoration>[...previousValue, ...decorations];
          });

      _initLog.info('Collected ${appDecorations.length} total app decorations');

      /// Build up the MethodHandler list. First takes priority.
      _initLog.info('Collecting method handlers');
      methodHandlers = allFeatures.fold<Map<String, MethodCallHandler>>(
          <String, MethodCallHandler>{},
          (previousValue, element) {
            final handlerCount = element.methodHandlers.length;
            if (handlerCount > 0) {
              _initLog.fine('Feature ${element.namespace}:${element.implementationName} provides ${handlerCount} method handlers');
            }
            return <String, MethodCallHandler>{}
              ..addAll(element.methodHandlers)
              ..addAll(previousValue);
          });

      _initLog.info('Collecting decoration allow/deny lists');
      pageDecorationDenyList = allFeatures.fold<List<String>>(
          <String>[],
          ((previousValue, element) =>
              <String>[...previousValue, ...element.pageDecorationDenyList]));
      
      pageDecorationAllowList = allFeatures.fold<List<String>>(
          <String>[],
          ((previousValue, element) =>
              <String>[...previousValue, ...element.pageDecorationAllowList]));
      
      whitelistedPageDecorations =
          pageDecorationAllowList.map((e) => e.split(':')[1]).toSet();

      /// register the selected implementation for each
      _initLog.info('Registering active implementations');
      activeImplementations.clear();
      
      // First collect all namespaces that have overrides with non-null values
      final namespacesWithOverrides = featureOverrides.entries
          .where((entry) => entry.value != null)
          .map((entry) => entry.key)
          .toSet();
      
      // For namespaces with overrides, use the override value directly
      // We know these values are non-null based on our filter above
      for (final namespace in namespacesWithOverrides) {
        // The value is guaranteed to be non-null based on our filter above
        activeImplementations[namespace] = featureOverrides[namespace]!;
      }
      
      // For namespaces without overrides, use the first implementation that was loaded
      allFeatures.forEach((element) {
        if (!(element is StubFeature) && !namespacesWithOverrides.contains(element.namespace)) {
          // Only set if not already set by an override
          if (!activeImplementations.containsKey(element.namespace)) {
            activeImplementations[element.namespace] = element.implementationName;
          }
        }
      });
      
      _initLog.info('Feature build process complete');
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
    return (widget.routeBuilder ??
            (Platform.isIOS
                ? kMaterialRouteResolver
                : kCupertinoRouteResolver))(
        settings, (ctx) => buildPageRoute(ctx, settings, definition));
  }

  /// Walks the feature tree and registers features in dependency order.
  /// Dependencies are processed before the features that depend on them.
  List<DartBoardFeature> buildDependencyList(List<DartBoardFeature> features,
      {List<DartBoardFeature> result = const <DartBoardFeature>[], 
      int depth = 0,
      Set<String> processingPath = const {}}) {
    
    for (final feature in features) {
      // Create a unique identifier for this feature to detect circular dependencies
      final featureId = '${feature.namespace}:${feature.implementationName}';
      
      // Check for circular dependencies
      if (processingPath.contains(featureId)) {
        _initLog.warning('Circular dependency detected while processing $featureId');
        _initLog.warning('Current dependency path: ${processingPath.join(' -> ')} -> $featureId');
        // We continue anyway to maintain compatibility
      }
      
      // Process dependencies with the current feature added to the path
      final updatedPath = {...processingPath, featureId};
      result = buildDependencyList(
        feature.dependencies, 
        result: result, 
        depth: depth + 1,
        processingPath: updatedPath
      );
      
      // Only add this feature if it's not already in the result list
      if (!result.contains(feature)) {
        // Check if this feature is enabled and not already in the result list with the same namespace/implementation
        if (feature.enabled &&
            result
                .where((element) =>
                    element.namespace == feature.namespace &&
                    element.implementationName == feature.implementationName)
                .isEmpty) {
          result = [...result, feature];
          
          if (depth == 0) {
            _initLog.fine('Added root feature: $featureId');
          } else {
            _initLog.fine('Added dependency: $featureId (depth: $depth)');
          }
        }
      }
    }
    return result;
  }

  @override
  void setFeatureImplementation(String namespace, String? value) {
    if (mounted) {
      setState(() {
        featureOverrides[namespace] = value;
        buildFeatures();
      });
    }
  }

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

  @override
  List<DartBoardFeature> get initialFeatures => widget.features;
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
