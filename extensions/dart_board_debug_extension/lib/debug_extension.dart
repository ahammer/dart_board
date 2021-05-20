import 'package:dart_board_interface/dart_board_core.dart';
import 'package:dart_board_interface/dart_board_feature.dart';
import 'package:flutter/material.dart';

/// This Extension is meant to expose the /Debug route,
///
/// It provides some information about the system
/// This is a rough first draft.
class DebugExtension extends DartBoardFeature {
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
            title: 'Extensions',
            child: ExtensionList(),
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

class ExtensionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(children: [
              TableCell(child: TitleText('Extension')),
              TableCell(child: TitleText('Routes')),
              TableCell(child: TitleText('Page Decorations')),
              TableCell(child: TitleText('App Decorations')),
              TableCell(child: TitleText('Dependencies')),
            ]),
            ...DartBoardCore.getExtensions().map((e) => TableRow(
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
                        extension: e,
                      )),
                      TableCell(child: CellText('${e.routes}', extension: e)),
                      TableCell(
                          child: CellText(
                              '${e.pageDecorations.map((e) => e.name)}',
                              extension: e)),
                      TableCell(
                          child: CellText('${e.appDecorations.length}',
                              extension: e)),
                      TableCell(
                          child: CellText('${e.dependencies}', extension: e))
                    ]))
          ]);
}

class ExtensionDetails extends StatelessWidget {
  final DartBoardFeature extension;

  const ExtensionDetails({Key? key, required this.extension}) : super(key: key);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(32.0),
        child: Material(child: Text(extension.namespace)),
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
  final DartBoardFeature extension;
  final String text;

  const CellText(
    this.text, {
    Key? key,
    required this.extension,
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
