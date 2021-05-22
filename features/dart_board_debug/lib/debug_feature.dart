import 'package:dart_board/dart_board.dart';
import 'package:flutter/material.dart';

/// This feature is meant to expose the /Debug route,
///
/// It provides some information about the system
/// This is a rough first draft.
class DebugFeature extends DartBoardFeature {
  @override
  List<WidgetWithChildBuilder> get appDecorations => [];

  @override
  List<PageDecoration> get pageDecorations => [];

  @override
  List<RouteDefinition> get routes => <RouteDefinition>[
        NamedRouteDefinition(
            route: '/debug', builder: (context, settings) => DebugScreen())
      ];

  @override
  String get namespace => 'debug';
}

class DebugScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
              child: DebugPanel(
            title: 'features',
            child: featureList(),
          )),
        ],
      );
}

class DebugPanel extends StatelessWidget {
  final String title;
  final Widget child;

  const DebugPanel({required this.title, required this.child, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => child;
}

class featureList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(children: [
              TableCell(child: TitleText('feature')),
              TableCell(child: TitleText('Routes')),
              TableCell(child: TitleText('Page Decorations')),
              TableCell(child: TitleText('App Decorations')),
              TableCell(child: TitleText('Dependencies')),
            ]),
            ...DartBoardCore.featureList.map((e) => TableRow(
                    decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surface
                            .withOpacity(0.8),
                        border: Border(
                            bottom:
                                BorderSide(width: 2, color: Colors.black12))),
                    children: [
                      TableCell(
                          child: CellText(
                        e.namespace,
                        feature: e,
                      )),
                      TableCell(child: CellText('${e.routes}', feature: e)),
                      TableCell(
                          child: CellText(
                              '${e.pageDecorations.map((e) => e.name)}',
                              feature: e)),
                      TableCell(
                          child: CellText('${e.appDecorations.length}',
                              feature: e)),
                      TableCell(
                          child: CellText('${e.dependencies}', feature: e))
                    ]))
          ]);
}

class featureDetails extends StatelessWidget {
  final DartBoardFeature feature;

  const featureDetails({Key? key, required this.feature}) : super(key: key);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(32.0),
        child: Material(child: Text(feature.namespace)),
      );
}

class TitleText extends StatelessWidget {
  final String text;
  const TitleText(
    this.text, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ));
}

class CellText extends StatelessWidget {
  final DartBoardFeature feature;
  final String text;

  const CellText(
    this.text, {
    Key? key,
    required this.feature,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 48,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ),
      );
}
