import 'package:dart_board_interface/dart_board_core.dart';
import 'package:dart_board_interface/dart_board_extension.dart';
import 'package:flutter/material.dart';

/// This Extension is meant to expose the /Debug route,
/// that should expose information about the extensions
class DebugExtension extends DartBoardExtension {
  @override
  get appDecorations => [];

  @override
  get pageDecorations => [];

  @override
  get routes => <RouteDefinition>[]
    ..addMap({"/debug": (context, settings) => DebugScreen()});

  @override
  String get namespace => "Debug Route Extension";
}

class DebugScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
              child: DebugPanel(
            title: "Extensions",
            child: ExtensionList(),
          )),
        ],
      );
}

class DebugPanel extends StatelessWidget {
  final String title;
  final Widget child;

  const DebugPanel({@required this.title, @required this.child, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => child;
}

class ExtensionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(children: [
            TableCell(child: TitleText("Extension")),
            TableCell(child: TitleText("Routes")),
            TableCell(child: TitleText("Page Decorations")),
            TableCell(child: TitleText("App Decorations")),
            TableCell(child: TitleText("Dependencies")),
          ]),
          ...DartBoardCore.getExtensions().map((e) => TableRow(children: [
                TableCell(child: CellText(e.namespace)),
                TableCell(child: CellText("${e.routes.length}")),
                TableCell(child: CellText("${e.pageDecorations.length}")),
                TableCell(child: CellText("${e.appDecorations.length}")),
                TableCell(child: CellText("${e.dependencies.length}"))
              ]))
        ]);
  }
}

class TitleText extends StatelessWidget {
  final String text;
  const TitleText(
    this.text, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ));
}

class CellText extends StatelessWidget {
  final String text;
  const CellText(
    this.text, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => TableRowInkWell(
      onTap: () {},
      child: Center(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      )));
}
