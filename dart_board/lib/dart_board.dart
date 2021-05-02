import 'package:dart_board_interface/dart_board_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'impl/widgets/route_not_found.dart';

class DartBoard extends StatefulWidget {
  /// These are the extensions we'll load
  final List<DartBoardExtension> extensions;
  final Widget pageNotFoundWidget;
  final Widget home;

  DartBoard(
      {Key key,
      this.extensions,
      this.pageNotFoundWidget = const RouteNotFound(),
      @required this.home})
      : super(key: key);

  @override
  _DartBoardState createState() => _DartBoardState();
}

class _DartBoardState extends State<DartBoard> {
  List<RouteDefinition> routes;
  List<WidgetWithChildBuilder> pageDecorations;

  @override
  void initState() {
    super.initState();

    /// We pull out Routes and PageDecorations from the route
    routes = widget.extensions.fold(
        <RouteDefinition>[],
        (previousValue, element) =>
            <RouteDefinition>[...previousValue, ...element.routes]);

    pageDecorations = widget.extensions.fold(
        <WidgetWithChildBuilder>[],
        (previousValue, element) => <WidgetWithChildBuilder>[
              ...previousValue,
              ...element.pageDecorations
            ]);
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        onGenerateRoute: onGenerateRoute,
        home: widget.home,
      );

  /// Generates a route from the extensions
  /// If it can't find, it falls back to route not found
  ///
  /// It'll also wrap a route with any decorations
  Route onGenerateRoute(settings) {
    try {
      return MaterialPageRoute(
          builder: (ctx) => pageDecorations.reversed.fold(
              routes
                  .where((it) => it.route == settings.name)
                  .first
                  .builder(ctx),
              (child, element) => element(ctx, child)));
    } on Exception {
      return MaterialPageRoute(builder: (ctx) => widget.pageNotFoundWidget);
    }
  }
}
