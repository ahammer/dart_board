import 'dart:math';

import 'package:dart_board_core/dart_board.dart';
import 'package:flutter/material.dart';

/// Debug Graph
///
class DebugGraph extends StatefulWidget {
  @override
  State<DebugGraph> createState() => _DebugGraphState();
}

class _DebugGraphState extends State<DebugGraph> {
  final _globalKeys = <String, GlobalKey>{};
  late final dbc = DartBoardCore.instance;
  late final result = featureLevels(features: dbc.initialFeatures, result: {});
  late final maxLevel = (result.values.toList()..sort()).last;
  late final edges = featureEdges(features: dbc.initialFeatures, result: {});

  @override
  void initState() {
    result.entries.forEach((element) {
      _globalKeys[element.key] = GlobalKey(debugLabel: element.key);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _LineDrawer(state: this),
        SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(maxLevel + 1, (index) => index)
                  .map((idx) => Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Wrap(
                          children: result.entries
                              .where((element) => element.value == idx)
                              .map((e) => Container(
                                    key: getKeyFor(e.key),
                                    child: FeatureNode(
                                      featureName: e.key,
                                    ),
                                  ))
                              .toList(),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  GlobalKey getKeyFor(String key) => _globalKeys[key]!;
}

class _LineDrawer extends StatefulWidget {
  final _DebugGraphState state;
  const _LineDrawer({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  State<_LineDrawer> createState() => _LineDrawerState();
}

class _LineDrawerState extends State<_LineDrawer> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _LinePainter(widget.state));
  }
}

class _LinePainter extends CustomPainter {
  final _DebugGraphState state;

  _LinePainter(this.state);
  @override
  void paint(Canvas canvas, Size size) {
    var idx = 0;
    state.edges.entries.forEach((primary) {
      idx = 0;
      primary.value.forEach((secondary) {
        final ro1 = state._globalKeys[primary.key]?.currentContext
            ?.findRenderObject() as RenderBox?;
        final ro2 = state._globalKeys[secondary]?.currentContext
            ?.findRenderObject() as RenderBox?;

        if (ro1 != null && ro2 != null) {
          drawConnection(canvas, ro1, ro2, idx);
        }
        idx++;
      });
    });
  }

  void drawConnection(
      Canvas canvas, RenderBox origin, RenderBox destination, int idx) {
    //ro2.localToGlobal(ro2.paintBounds.center)

    final offset = Offset(idx.toDouble() * 1.5 - 16, idx.toDouble() * 1.5 - 16);
    final p1 = origin.localToGlobal(origin.paintBounds.center);
    final p2 = origin.localToGlobal(origin.paintBounds.centerRight);
    final p5 = destination
        .localToGlobal(destination.paintBounds.topCenter - Offset(0, 8));
    final p6 = destination.localToGlobal(destination.paintBounds.center);
    final p3 = Offset(p2.dx, p5.dy);
    final color =
        HSLColor.fromAHSL(1.0, (origin.hashCode / 100) % 360, 1.0, 0.6)
            .toColor();
    canvas.drawLine(
        p1,
        p2 + offset,
        Paint()
          ..color = color
          ..strokeWidth = 1.5);
    canvas.drawLine(
        p2 + offset,
        p3 + offset,
        Paint()
          ..color = color
          ..strokeWidth = 1.5);
    canvas.drawLine(
        p3 + offset,
        p5 + offset,
        Paint()
          ..color = color
          ..strokeWidth = 1.5);
    canvas.drawLine(
        p5 + offset,
        p6 + offset,
        Paint()
          ..color = color
          ..strokeWidth = 1.5);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class FeatureNode extends StatelessWidget {
  const FeatureNode({
    Key? key,
    required this.featureName,
  }) : super(key: key);

  final String featureName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
          key: ValueKey(featureName),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: SizedBox(
            width: 150,
            height: 50,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  featureName,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ),
          )),
    );
  }
}

Map<String, int> featureLevels(
    {int depth = 0,
    required List<DartBoardFeature> features,
    required Map<String, int> result}) {
  if (features.isEmpty) return result;

  /// Walk the tree and add up the children
  features.forEach((element) {
    result[element.namespace] = max(depth, result[element.namespace] ?? 0);
    featureLevels(
        features: element.dependencies, depth: depth + 1, result: result);
  });

  return result;
}

/// Find a set of edges for each feature
Map<String, Set<String>> featureEdges(
    {int depth = 0,
    required List<DartBoardFeature> features,
    required Map<String, Set<String>> result}) {
  if (features.isEmpty) return result;

  /// Walk the tree and add up the children
  features.forEach((element) {
    /// Add the node for edges
    if (!result.containsKey(element.namespace)) {
      result[element.namespace] = {};
    }

    result[element.namespace]
        ?.addAll(element.dependencies.map((e) => e.namespace));

    featureEdges(
        features: element.dependencies, depth: depth + 1, result: result);
  });

  return result;
}
