import 'package:dart_board_core/dart_board_core.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

/// A DartBoard feature that provides diagnostic tools for debugging
/// initialization issues and feature dependencies.
///
/// Add this feature to your DartBoard instance to gain access to
/// a diagnostic page and tools for understanding feature initialization.
class DiagnosticFeature extends DartBoardFeature {
  @override
  String get namespace => 'DiagnosticTools';

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
          route: '/diagnostics',
          builder: (context, settings) => InitializationDiagnostics.createDiagnosticsPage(),
        ),
      ];

  @override
  List<DartBoardDecoration> get appDecorations => [
        DartBoardDecoration(
          name: 'DiagnosticTools',
          decoration: (context, child) {
            // Log initialization order information at startup
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _logDiagnosticSummary();
            });
            return child;
          },
        ),
      ];

  /// Logs a summary of the initialization diagnostics to the console
  void _logDiagnosticSummary() {
    final log = Logger('DiagnosticFeature');
    final core = DartBoardCore.instance;
    
    log.info('Dart Board Initialization Summary:');
    log.info('- Total features: ${core.allFeatures.length}');
    log.info('- Active features: ${core.loadedFeatures.length}');
    log.info('- Routes: ${core.routes.length}');
    
    // Log multiple implementations
    final implementations = <String, List<String>>{};
    for (final feature in core.allFeatures) {
      if (!implementations.containsKey(feature.namespace)) {
        implementations[feature.namespace] = [];
      }
      if (!implementations[feature.namespace]!.contains(feature.implementationName)) {
        implementations[feature.namespace]!.add(feature.implementationName);
      }
    }
    
    final multipleImpls = implementations.entries
        .where((entry) => entry.value.length > 1)
        .toList();
    
    if (multipleImpls.isNotEmpty) {
      log.info('Features with multiple implementations:');
      for (final entry in multipleImpls) {
        log.info('  - ${entry.key}: ${entry.value.join(', ')}');
      }
    }
    
    // We can't directly access private methods, so we'll create a simpler check
    // to detect potential circular dependencies without using the private method
    log.info('Checking for potential circular dependencies...');
    // Instead of using the private method, we'll use the diagnostics report
    final report = DartBoardCore.instance.generateDiagnosticReport();
    if (report.contains('Potential Circular Dependencies Detected')) {
      log.warning('Potential circular dependencies detected, check /diagnostics for details');
    }
    
    log.info('For detailed diagnostics, navigate to /diagnostics');
  }
}

/// Adds a diagnostic route to any feature
class DiagnosticRouteExtension extends DartBoardFeature {
  final String routePath;
  
  DiagnosticRouteExtension({this.routePath = '/diagnostics'});
  
  @override
  String get namespace => 'DiagnosticRoute';
  
  @override
  List<RouteDefinition> get routes => [
    NamedRouteDefinition(
      route: routePath,
      builder: (context, settings) => InitializationDiagnostics.createDiagnosticsPage(),
    ),
  ];
}
