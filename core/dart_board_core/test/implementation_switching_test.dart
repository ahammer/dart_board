import 'package:dart_board_core/dart_board_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test feature with multiple implementations
class SwitchableFeature extends DartBoardFeature {
  final String _implementationName;
  final String _displayText;

  SwitchableFeature({
    required String implementationName,
    required String displayText,
  })  : _implementationName = implementationName,
        _displayText = displayText;

  @override
  String get namespace => 'switchable';

  @override
  String get implementationName => _implementationName;

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
          route: '/switchable',
          builder: (ctx, settings) => Material(
            child: Center(
              key: ValueKey('switchable_implementation_${implementationName}'),
              child: Text(
                _displayText,
                key: ValueKey('switchable_text'),
              ),
            ),
          ),
        ),
      ];
}

/// This is a consumer feature that depends on SwitchableFeature
class ConsumerFeature extends DartBoardFeature {
  final DartBoardFeature _dependency;

  ConsumerFeature(this._dependency);

  @override
  String get namespace => 'consumer';

  @override
  List<DartBoardFeature> get dependencies => [_dependency];

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
          route: '/consumer',
          builder: (ctx, settings) => Material(
            child: Center(
              child: ElevatedButton(
                key: ValueKey('navigate_button'),
                child: Text('Navigate to Switchable'),
                onPressed: () {
                  DartBoardCore.nav.push('/switchable');
                },
              ),
            ),
          ),
        ),
      ];
}

/// A test harness widget that allows us to trigger implementation changes
class _TestHarness extends StatefulWidget {
  final List<DartBoardFeature> features;
  final Map<String, String?>? featureOverrides;
  
  _TestHarness({
    required this.features,
    this.featureOverrides,
  });
  
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
  
  @override
  Widget build(BuildContext context) {
    return DartBoard(
      initialPath: '/consumer',
      features: widget.features,
      featureOverrides: widget.featureOverrides,
    );
  }
}

void main() {
  group('Implementation switching tests', () {
    testWidgets('Active implementation should change when switched', (tester) async {
      // Create multiple implementations of the same feature
      final impl1 = SwitchableFeature(
        implementationName: 'impl1', 
        displayText: 'Implementation 1'
      );
      final impl2 = SwitchableFeature(
        implementationName: 'impl2',
        displayText: 'Implementation 2'
      );
      
      // Create a consumer feature that depends on only one implementation
      final consumerFeature = ConsumerFeature(impl1);
      
      // Create the test harness with both implementations registered at the integration level
      final testWidget = _TestHarness(
        features: [consumerFeature, impl2],
      );
      
      // Initialize widget and wait for it to settle
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      
      // Tap the navigation button to navigate to the switchable feature
      await tester.tap(find.byKey(ValueKey('navigate_button')));
      await tester.pumpAndSettle();
      
      // Verify that implementation 1 is active
      expect(find.text('Implementation 1'), findsOneWidget);
      expect(DartBoardCore.instance.activeImplementations['switchable'], equals('impl1'));
      
      // Switch to implementation 2
      _TestHarnessState.instance?.setFeatureImplementation('switchable', 'impl2');
      await tester.pump();
      await tester.pumpAndSettle();
      
      // Verify that implementation 2 is now active
      expect(find.text('Implementation 2'), findsOneWidget);
      expect(DartBoardCore.instance.activeImplementations['switchable'], equals('impl2'));
    });
    
    testWidgets('Implementation can be explicitly selected at initialization', (tester) async {
      // Create multiple implementations of the same feature
      final impl1 = SwitchableFeature(
        implementationName: 'impl1', 
        displayText: 'Implementation 1'
      );
      final impl2 = SwitchableFeature(
        implementationName: 'impl2',
        displayText: 'Implementation 2'
      );
      
      // Create a consumer feature that depends on one implementation
      final consumerFeature = ConsumerFeature(impl1);
      
      // Create the test harness with both implementations registered at the integration level
      // but with impl2 explicitly selected via overrides
      final testWidget = _TestHarness(
        features: [consumerFeature, impl2],
        featureOverrides: {'switchable': 'impl2'},
      );
      
      // Initialize widget and wait for it to settle
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      
      // Tap the navigation button to navigate to the switchable feature
      await tester.tap(find.byKey(ValueKey('navigate_button')));
      await tester.pumpAndSettle();
      
      // Verify that implementation 2 is active from the start
      expect(find.text('Implementation 2'), findsOneWidget);
      expect(DartBoardCore.instance.activeImplementations['switchable'], equals('impl2'));
    });
    
    testWidgets('Implementation can be disabled with null override', (tester) async {
      // Create implementations
      final impl1 = SwitchableFeature(
        implementationName: 'impl1', 
        displayText: 'Implementation 1'
      );
      
      // Create a test harness with the feature disabled
      final testWidget = _TestHarness(
        features: [impl1],
        featureOverrides: {'switchable': null},
      );
      
      // Initialize widget and wait for it to settle
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      
      // Verify that the feature is not active
      expect(DartBoardCore.instance.isFeatureActive('switchable'), isFalse);
      
      // Try to navigate to the disabled feature's route
      DartBoardCore.nav.push('/switchable');
      await tester.pumpAndSettle();
      
      // Should show route not found since the feature is disabled
      expect(find.text('Implementation 1'), findsNothing);
    });
    
    testWidgets('Implementation can be re-enabled after being disabled', (tester) async {
      // Create implementations
      final impl1 = SwitchableFeature(
        implementationName: 'impl1', 
        displayText: 'Implementation 1'
      );
      final impl2 = SwitchableFeature(
        implementationName: 'impl2',
        displayText: 'Implementation 2'
      );
      
      // Create a consumer that depends on one implementation
      final consumerFeature = ConsumerFeature(impl1);
      
      // Create the test harness with both implementations but feature initially disabled
      final testWidget = _TestHarness(
        features: [consumerFeature, impl2],
        featureOverrides: {'switchable': null},
      );
      
      // Initialize widget and wait for it to settle
      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();
      
      // Verify that the feature is not active
      expect(DartBoardCore.instance.isFeatureActive('switchable'), isFalse);
      
      // Re-enable with specific implementation
      _TestHarnessState.instance?.setFeatureImplementation('switchable', 'impl2');
      await tester.pump();
      await tester.pumpAndSettle();
      
      // Tap the navigation button to navigate to the switchable feature
      await tester.tap(find.byKey(ValueKey('navigate_button')));
      await tester.pumpAndSettle();
      
      // Verify that implementation 2 is now active
      expect(find.text('Implementation 2'), findsOneWidget);
      expect(DartBoardCore.instance.activeImplementations['switchable'], equals('impl2'));
      expect(DartBoardCore.instance.isFeatureActive('switchable'), isTrue);
    });
  });
}
