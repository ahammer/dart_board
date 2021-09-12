import 'package:dart_board_core/dart_board.dart';
import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

class DebugGraph extends StatefulWidget {
  @override
  State<DebugGraph> createState() => _DebugGraphState();
}

class _DebugGraphState extends State<DebugGraph> {
  bool includeIntegrationFeature = false;

  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (ctx, constraints) {
        final graph = Graph();
        final nodes = <String, Node>{};

        /// Pass 1, register all the nodes
        DartBoardCore.instance.loadedFeatures
            .where((element) =>
                !element.isIntegrationFeature || includeIntegrationFeature)
            .forEach((feature) {
          nodes[feature.namespace] = Node(createNode(
              context,
              feature.namespace,
              HSLColor.fromAHSL(
                      1.0, (feature.namespace.hashCode % 360), 1.0, 0.4)
                  .toColor()));
        });

        /// Pass 2, add the edges
        DartBoardCore.instance.loadedFeatures.forEach((feature) {
          feature.dependencies.forEach((secondFeature) {
            final n1 = nodes[feature.namespace];
            final n2 = nodes[secondFeature.namespace];
            final col = HSLColor.fromAHSL(
                    1.0, (feature.namespace.hashCode % 360), 1.0, 0.4)
                .toColor();
            print(
                'adding edge: ${feature.namespace} -> ${secondFeature.namespace}');
            if (n1 != null && n2 != null) {
              graph.addEdge(n1, n2,
                  paint: Paint()
                    ..color = col
                    ..strokeWidth = 4);
            }
          });
        });

        final builder1 = SugiyamaConfiguration()
          ..levelSeparation = constraints.maxHeight ~/ 4
          ..nodeSeparation = constraints.maxWidth ~/ 10
          ..orientation = (SugiyamaConfiguration.ORIENTATION_TOP_BOTTOM);

        var builder = SugiyamaAlgorithm(builder1);

        return Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                Center(
                    child: InteractiveViewer(
                        key: ValueKey(includeIntegrationFeature),
                        constrained: false,
                        boundaryMargin: EdgeInsets.all(500),
                        minScale: 0.001,
                        maxScale: 1.0,
                        child: GraphView(
                          graph: graph,
                          algorithm: builder,
                        ))),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Card(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('  Include Integration'),
                        Switch(
                          onChanged: (val) {
                            setState(() {
                              includeIntegrationFeature =
                                  !includeIntegrationFeature;
                            });
                          },
                          value: includeIntegrationFeature,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ));
      });
}

Widget createNode(BuildContext context, String nodeText, Color c) => Container(
    decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(blurRadius: 5, spreadRadius: 5, color: c)]),
    child: Padding(
      padding: const EdgeInsets.all(2.0),
      child: Text(
        nodeText,
        style: Theme.of(context).textTheme.headline4,
      ),
    ));
