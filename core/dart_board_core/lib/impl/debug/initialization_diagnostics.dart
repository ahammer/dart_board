import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dart_board_core/dart_board_core.dart';
import 'package:logging/logging.dart';

/// A utility class to help diagnose initialization issues in dart_board_core
class InitializationDiagnostics {
  static final Logger _log = Logger('DartBoard.Diagnostics');
  
  /// Returns a detailed dependency graph of all features currently loaded
  /// This can be used to visualize and debug initialization order issues
  static String generateDependencyGraph() {
    final core = DartBoardCore.instance;
    final features = core.allFeatures;
    final loadedFeatures = core.loadedFeatures;
    
    final buffer = StringBuffer();
    buffer.writeln('# Dart Board Initialization Diagnostic Report');
    buffer.writeln('Generated at: ${DateTime.now().toLocal()}');
    buffer.writeln();
    
    // Generate summary statistics
    buffer.writeln('## Summary');
    buffer.writeln('- Total features: ${features.length}');
    buffer.writeln('- Active features: ${loadedFeatures.length}');
    buffer.writeln('- Routes: ${core.routes.length}');
    buffer.writeln('- App decorations: ${core.appDecorations.length}');
    buffer.writeln('- Page decorations: ${core.pageDecorations.length}');
    buffer.writeln('- Method handlers: ${core.methodHandlers.length}');
    buffer.writeln();
    
    // Generate feature activation status table
    buffer.writeln('## Feature Activation Status');
    buffer.writeln('| Namespace | Implementation | Status | Dependencies |');
    buffer.writeln('|-----------|----------------|--------|--------------|');
    
    for (final feature in features) {
      final isActive = loadedFeatures.contains(feature);
      final status = isActive ? 'Active' : 'Inactive';
      final dependencies = feature.dependencies
          .map((dep) => '${dep.namespace}:${dep.implementationName}')
          .join(', ');
      
      buffer.writeln('| ${feature.namespace} | ${feature.implementationName} | $status | $dependencies |');
    }
    buffer.writeln();
    
    // Generate mermaid dependency graph
    buffer.writeln('## Dependency Graph (Mermaid)');
    buffer.writeln('```mermaid');
    buffer.writeln('graph TD');
    
    // Add nodes
    for (final feature in features) {
      final nodeId = '${feature.namespace}_${feature.implementationName}'.replaceAll(' ', '_');
      final nodeLabel = '${feature.namespace}:${feature.implementationName}';
      final style = loadedFeatures.contains(feature) ? 'fill:#d4f0c4' : 'fill:#f9c4c4';
      
      buffer.writeln('    $nodeId["$nodeLabel"]:::${loadedFeatures.contains(feature) ? 'active' : 'inactive'}');
    }
    
    buffer.writeln('    classDef active fill:#d4f0c4,stroke:#82c341,stroke-width:2px');
    buffer.writeln('    classDef inactive fill:#f9c4c4,stroke:#e06666,stroke-width:2px');
    
    // Add edges
    for (final feature in features) {
      final nodeId = '${feature.namespace}_${feature.implementationName}'.replaceAll(' ', '_');
      
      for (final dep in feature.dependencies) {
        final depNodeId = '${dep.namespace}_${dep.implementationName}'.replaceAll(' ', '_');
        buffer.writeln('    $depNodeId --> $nodeId');
      }
    }
    
    buffer.writeln('```');
    buffer.writeln();
    
    // Add initialization advice
    buffer.writeln('## Initialization Analysis');
    
    // Check for potential circular dependencies
    final circularDeps = _detectCircularDependencies(features);
    if (circularDeps.isNotEmpty) {
      buffer.writeln('### ⚠️ Potential Circular Dependencies Detected');
      buffer.writeln('The following dependency cycles were detected:');
      for (final cycle in circularDeps) {
        buffer.writeln('- ${cycle.join(' → ')} → ${cycle.first}');
      }
      buffer.writeln();
      buffer.writeln('Circular dependencies can cause initialization issues and should be refactored.');
      buffer.writeln();
    } else {
      buffer.writeln('✅ No circular dependencies detected');
      buffer.writeln();
    }
    
    // Check for multiple implementations
    final multipleImplementations = <String, List<String>>{};
    for (final feature in features) {
      if (!multipleImplementations.containsKey(feature.namespace)) {
        multipleImplementations[feature.namespace] = [];
      }
      if (!multipleImplementations[feature.namespace]!.contains(feature.implementationName)) {
        multipleImplementations[feature.namespace]!.add(feature.implementationName);
      }
    }
    
    final featuresWithMultipleImpls = multipleImplementations.entries
        .where((entry) => entry.value.length > 1)
        .toList();
    
    if (featuresWithMultipleImpls.isNotEmpty) {
      buffer.writeln('### Multiple Implementations');
      buffer.writeln('The following features have multiple implementations:');
      for (final entry in featuresWithMultipleImpls) {
        buffer.writeln('- ${entry.key}: ${entry.value.join(', ')}');
      }
      buffer.writeln();
      buffer.writeln('Ensure the correct implementation is being selected through featureOverrides if needed.');
      buffer.writeln();
    }
    
    return buffer.toString();
  }
  
  /// Detects potential circular dependencies in the feature list
  /// Returns a list of cycles found, where each cycle is a list of feature IDs
  static List<List<String>> _detectCircularDependencies(List<DartBoardFeature> features) {
    final cycles = <List<String>>[];
    final visited = <String>{};
    final recursionStack = <String>{};
    
    void dfs(DartBoardFeature feature, List<String> path) {
      final featureId = '${feature.namespace}:${feature.implementationName}';
      
      // If we've seen this feature in our current recursion stack, we have a cycle
      if (recursionStack.contains(featureId)) {
        // Find where in the path this feature first appeared to identify the cycle
        final cycleStart = path.indexOf(featureId);
        if (cycleStart >= 0) {
          final cycle = path.sublist(cycleStart);
          cycles.add(cycle);
        }
        return;
      }
      
      // If we've already fully explored this feature, no need to do it again
      if (visited.contains(featureId)) {
        return;
      }
      
      // Add to recursion stack for cycle detection
      recursionStack.add(featureId);
      path.add(featureId);
      
      // Explore dependencies
      for (final dep in feature.dependencies) {
        dfs(dep, [...path]);
      }
      
      // Remove from recursion stack as we're done exploring this branch
      recursionStack.remove(featureId);
      // Mark as fully visited
      visited.add(featureId);
    }
    
    // Start DFS from each feature to find all possible cycles
    for (final feature in features) {
      if (!visited.contains('${feature.namespace}:${feature.implementationName}')) {
        dfs(feature, []);
      }
    }
    
    return cycles;
  }
  
  /// Returns a list of active features with their properties for debugging
  static List<Map<String, dynamic>> getFeatureDetails() {
    final core = DartBoardCore.instance;
    final features = core.allFeatures;
    
    return features.map((feature) {
      final isActive = core.loadedFeatures.contains(feature);
      return {
        'namespace': feature.namespace,
        'implementationName': feature.implementationName,
        'active': isActive,
        'dependencies': feature.dependencies.map((dep) => 
            {'namespace': dep.namespace, 'implementationName': dep.implementationName}).toList(),
        'routeCount': feature.routes.length,
        'appDecorationCount': feature.appDecorations.length,
        'pageDecorationCount': feature.pageDecorations.length, 
        'methodHandlerCount': feature.methodHandlers.length,
      };
    }).toList();
  }
  
  /// Creates a debug page widget that shows initialization diagnostics
  static Widget createDiagnosticsPage() {
    return _InitializationDiagnosticsPage();
  }
}

/// A diagnostic page that displays initialization information
class _InitializationDiagnosticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final diagnostics = InitializationDiagnostics.generateDependencyGraph();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Initialization Diagnostics'),
        actions: [
          IconButton(
            icon: Icon(Icons.copy),
            onPressed: () {
              // Copy the diagnostic report to clipboard
              final data = ClipboardData(text: diagnostics);
              Clipboard.setData(data);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Diagnostic report copied to clipboard')),
              );
            },
            tooltip: 'Copy to clipboard',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SelectableText(diagnostics),
        ),
      ),
    );
  }
}

/// Extensions methods to add diagnostic capabilities to DartBoardCore
extension DiagnosticExtensions on DartBoardCore {
  /// Generate and return a detailed diagnostic report
  String generateDiagnosticReport() {
    return InitializationDiagnostics.generateDependencyGraph();
  }
  
  /// Export the diagnostic information to JSON
  String exportDiagnosticJson() {
    final data = {
      'timestamp': DateTime.now().toIso8601String(),
      'features': InitializationDiagnostics.getFeatureDetails(),
      'activeImplementations': activeImplementations,
      'routeCount': routes.length,
      'appDecorationCount': appDecorations.length,
      'pageDecorationCount': pageDecorations.length,
      'methodHandlerCount': methodHandlers.length,
    };
    
    return const JsonEncoder.withIndent('  ').convert(data);
  }
}
