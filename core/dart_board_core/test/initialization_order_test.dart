import 'package:dart_board_core/dart_board_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// This test file focuses specifically on initialization order issues
/// to ensure that any improvements to dart_board_core maintain
/// the critical initialization sequence.

// A static counter to track processing order
int _processingCounter = 0;

// A test feature that tracks its initialization and processing order
class LoggingFeature extends DartBoardFeature {
  final String _namespace;
  final String _implementationName;
  final List<String> initLog;
  final List<DartBoardFeature> _dependencies;
  final bool _enabled;
  
  // Track the order in which this feature was processed
  int processOrder = -1;

  LoggingFeature({
    required String namespace,
    String implementationName = 'default',
    required this.initLog,
    List<DartBoardFeature> dependencies = const [],
    bool enabled = true,
  })  : _namespace = namespace,
        _implementationName = implementationName,
        _dependencies = dependencies,
        _enabled = enabled {
    // Log creation time
    initLog.add('Created: $namespace:$implementationName');
    // Record initial processing order
    recordProcessing();
  }
  
  // Record that this feature is being processed by assigning the next counter value
  void recordProcessing() {
    processOrder = ++_processingCounter;
    initLog.add('Processed: $namespace:$implementationName (order: $processOrder)');
  }

  @override
  String get namespace => _namespace;

  @override
  String get implementationName => _implementationName;

  @override
  List<DartBoardFeature> get dependencies => _dependencies;

  @override
  bool get enabled => _enabled;

  @override
  List<RouteDefinition> get routes {
    initLog.add('Routes requested: $namespace:$implementationName');
    return [
      NamedRouteDefinition(
        route: '/$namespace',
        builder: (ctx, settings) => Material(
          child: Center(
            child: Text('$namespace:$implementationName'),
          ),
        ),
      ),
    ];
  }

  @override
  List<DartBoardDecoration> get appDecorations {
    initLog.add('AppDecorations requested: $namespace:$implementationName');
    return [];
  }

  @override
  List<DartBoardDecoration> get pageDecorations {
    initLog.add('PageDecorations requested: $namespace:$implementationName');
    return [];
  }
}

// A test feature for testing locator behavior
class TestLocatorFeature extends DartBoardFeature {
  final List<String> initLog;
  int processOrder = -1;
  
  TestLocatorFeature(this.initLog) {
    // Record creation for orderability
    recordProcessing();
  }

  void recordProcessing() {
    processOrder = ++_processingCounter;
    initLog.add('TestLocator: processed (order: $processOrder)');
  }

  @override
  String get namespace => "TestLocator";

  @override
  List<DartBoardDecoration> get appDecorations {
    initLog.add('TestLocator: appDecorations called');
    // Ensure registration happens first - this is critical!
    initLog.add('TestLocator: registration complete');
    
    return [
      DartBoardDecoration(
        name: 'TestLocatorRegistration',
        decoration: (context, child) {
          // This code runs later during UI building - after consumer feature initialization
          initLog.add('TestLocator: decoration running at build time');
          return child;
        },
      ),
    ];
  }
}

// A test feature that depends on locator
class LocatorConsumerFeature extends DartBoardFeature {
  final List<String> initLog;
  final List<DartBoardFeature> _dependencies;
  int processOrder = -1;

  LocatorConsumerFeature(this.initLog, this._dependencies) {
    // Record creation for orderability
    recordProcessing();
  }
  
  void recordProcessing() {
    processOrder = ++_processingCounter;
    initLog.add('LocatorConsumer: processed (order: $processOrder)');
  }

  @override
  String get namespace => "LocatorConsumer";

  @override
  List<DartBoardFeature> get dependencies => _dependencies;

  @override
  List<DartBoardDecoration> get appDecorations {
    initLog.add('LocatorConsumer: appDecorations called');
    
    // Try to use the locator - this should happen after registration
    initLog.add('LocatorConsumer: trying to use locator');
    
    return [
      DartBoardDecoration(
        name: 'LocatorConsumerUsage',
        decoration: (context, child) {
          // This code runs even later during UI building
          initLog.add('LocatorConsumer: usage in decoration');
          return child;
        },
      ),
    ];
  }
}

void main() {
  testWidgets('Circular dependencies terminate and register each feature once', (tester) async {
    final dependencies = <DartBoardFeature>[];
    final initLog = <String>[];
    final a = LoggingFeature(namespace: 'A', initLog: initLog, dependencies: dependencies);
    final b = LoggingFeature(namespace: 'B', initLog: initLog, dependencies: [a]);
    dependencies.add(b);
    await tester.pumpWidget(DartBoard(initialPath: '/A', features: [a]));
    await tester.pumpAndSettle();
    expect(DartBoardCore.instance.allFeatures, [b, a]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Unknown overrides are not reported as active', (tester) async {
    await tester.pumpWidget(DartBoard(
      initialPath: '/main',
      features: [LoggingFeature(namespace: 'A', initLog: [])],
      featureOverrides: {'A': 'missing', 'unknown': 'default'},
    ));
    await tester.pumpAndSettle();
    expect(DartBoardCore.instance.activeImplementations, isEmpty);
  });

  testWidgets('Feature initialization order follows dependency graph', (tester) async {
    final initLog = <String>[];

    // Create features with dependencies
    final featureC = LoggingFeature(namespace: 'C', initLog: initLog);
    final featureB = LoggingFeature(namespace: 'B', initLog: initLog, dependencies: [featureC]);
    final featureA = LoggingFeature(namespace: 'A', initLog: initLog, dependencies: [featureB]);

    // Initialize DartBoard with the top-level feature
    await tester.pumpWidget(DartBoard(
      initialPath: '/main',
      features: [featureA],
    ));
    await tester.pumpAndSettle();

    final requests = initLog.where((entry) => entry.startsWith('Routes requested:')).toList();
    expect(requests, [
      'Routes requested: C:default',
      'Routes requested: B:default',
      'Routes requested: A:default',
    ]);
  });

  testWidgets('Disabled features are handled correctly', (tester) async {
    final initLog = <String>[];

    // Create features with a disabled feature
    final featureC = LoggingFeature(namespace: 'C', initLog: initLog, enabled: false);
    final featureB = LoggingFeature(namespace: 'B', initLog: initLog, dependencies: [featureC]);
    final featureA = LoggingFeature(namespace: 'A', initLog: initLog, dependencies: [featureB]);

    // Initialize DartBoard with the top-level feature
    await tester.pumpWidget(DartBoard(
      initialPath: '/main',
      features: [featureA],
      featureOverrides: {'C': null}, // Explicitly disable C
    ));
    await tester.pumpAndSettle();

    // Verify that route registration is not called for disabled features
    final routeRequestsC = initLog.where((log) => log.contains('Routes requested: C:default')).toList();
    expect(routeRequestsC.length, equals(0));
  });

  testWidgets('Feature override selection works correctly', (tester) async {
    final initLog = <String>[];

    // Create multiple implementations of the same feature
    final featureC1 = LoggingFeature(namespace: 'C', implementationName: 'impl1', initLog: initLog);
    final featureC2 = LoggingFeature(namespace: 'C', implementationName: 'impl2', initLog: initLog);
    final featureB = LoggingFeature(namespace: 'B', initLog: initLog, dependencies: [featureC1, featureC2]);
    final featureA = LoggingFeature(namespace: 'A', initLog: initLog, dependencies: [featureB]);

    // Initialize DartBoard with override to select impl2
    await tester.pumpWidget(DartBoard(
      initialPath: '/main',
      features: [featureA],
      featureOverrides: {'C': 'impl2'},
    ));
    await tester.pumpAndSettle();

    // Verify that route registration is only called for the selected implementation
    final routeRequestsC1 = initLog.where((log) => log.contains('Routes requested: C:impl1')).toList();
    final routeRequestsC2 = initLog.where((log) => log.contains('Routes requested: C:impl2')).toList();
    expect(routeRequestsC1.length, equals(0));
    expect(routeRequestsC2.length, greaterThan(0));
  });

  testWidgets('Locator feature initialization order test', (tester) async {
    final initLog = <String>[];

    // Create a locator and a consumer feature
    final locatorFeature = TestLocatorFeature(initLog);
    final consumerFeature = LocatorConsumerFeature(initLog, [locatorFeature]);

    // Initialize DartBoard with both features
    await tester.pumpWidget(DartBoard(
      initialPath: '/main',
      features: [consumerFeature],
    ));
    await tester.pumpAndSettle();

    // Verify locator initialization happens before consumer usage
    int locatorInit = initLog.indexWhere((log) => log.contains('TestLocator: registration complete'));
    int consumerUsage = initLog.indexWhere((log) => log.contains('LocatorConsumer: trying to use locator'));

    expect(locatorInit, isNot(-1));
    expect(consumerUsage, isNot(-1));
    expect(locatorInit, lessThan(consumerUsage), 
        reason: 'Locator must be registered before consumers try to use it');
  });

  testWidgets('buildFeatures rebuilds features correctly', (tester) async {
    // Reset counter before test
    _processingCounter = 0;
    final initLog = <String>[];

    // Create features - both implementations of B must be registered
    final featureB = LoggingFeature(namespace: 'B', implementationName: 'default', initLog: initLog);
    final featureBAlternative = LoggingFeature(namespace: 'B', implementationName: 'other', initLog: initLog);
    final featureA = LoggingFeature(namespace: 'A', initLog: initLog, dependencies: [featureB, featureBAlternative]);

    // Create a test harness that will allow us to trigger buildFeatures
    // Make sure both implementations of B are registered by including them in features
    final testWidget = _TestHarness(
      initLog: initLog,
      features: [featureA, featureBAlternative],
    );

    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();
    
    expect(DartBoardCore.instance.loadedFeatures, contains(featureB));
    expect(DartBoardCore.instance.loadedFeatures, isNot(contains(featureBAlternative)));
    initLog.clear();

    testWidget.changeImplementation('B', 'other');
    await tester.pumpAndSettle();

    expect(DartBoardCore.instance.loadedFeatures, contains(featureBAlternative));
    expect(DartBoardCore.instance.loadedFeatures, isNot(contains(featureB)));
    expect(initLog, contains('Routes requested: B:other'));
    expect(initLog, isNot(contains('Routes requested: B:default')));
    expect(initLog.indexOf('Routes requested: B:other'),
        lessThan(initLog.indexOf('Routes requested: A:default')));
  });
}

/// A test harness widget that allows us to trigger buildFeatures
class _TestHarness extends StatefulWidget {
  final List<String> initLog;
  final List<DartBoardFeature> features;
  
  _TestHarness({required this.initLog, required this.features});
  
  void changeImplementation(String namespace, String? implementation) {
    _TestHarnessState.instance?.setFeatureImplementation(namespace, implementation);
  }

  @override
  _TestHarnessState createState() => _TestHarnessState();
}

class _TestHarnessState extends State<_TestHarness> {
  static _TestHarnessState? instance;
  
  @override
  void initState() {
    super.initState();
    instance = this;
  }
  
  void setFeatureImplementation(String namespace, String? implementation) {
    if (!mounted) return;
    
    DartBoardCore.instance.setFeatureImplementation(namespace, implementation);    
  }
  
  dynamic findDartBoardState(BuildContext context) {
    // This is a bit of a hack to get access to the DartBoardState
    // In a real implementation, we'd use a proper way to communicate with DartBoardCore
    final dartBoard = context.findAncestorWidgetOfExactType<DartBoard>();
    final element = dartBoard != null ? context.findAncestorStateOfType<State<DartBoard>>() : null;
    return element;
  }
  
  @override
  Widget build(BuildContext context) {
    return DartBoard(
      initialPath: '/main',
      features: widget.features,
    );
  }
}
