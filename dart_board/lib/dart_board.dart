import 'package:dart_board_interface/dart_board_core.dart';
import 'package:dart_board_interface/dart_board_extension.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'impl/widgets/route_not_found.dart';

/// The Dart Board Entry Point
///
/// Give it a 404 Widget
/// Give it Extensions
/// Give it the InitialRoute
///
/// The kernel is designed to stay simple
///
class DartBoard extends StatefulWidget {
  /// These are the extensions we'll load
  final List<DartBoardExtension> extensions;
  final Widget pageNotFoundWidget;
  final String initialRoute;

  DartBoard(
      {Key key,
      this.extensions,
      this.pageNotFoundWidget = const RouteNotFound(),
      @required this.initialRoute})
      : super(key: key);

  @override
  _DartBoardState createState() => _DartBoardState();
}

/// The Dart Board State
/// We unwrap the routes
/// We also unwrap the decorations
/// Then we build the MaterialApp()
class _DartBoardState extends State<DartBoard> implements DartBoardCore {
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

  /// Simple build
  @override
  Widget build(BuildContext context) => Provider<DartBoardCore>(
        create: (ctx) => this,
        child: MaterialApp(
          key: dartBoardKey,
          initialRoute: widget.initialRoute,
          onGenerateRoute: onGenerateRoute,
        ),
      );

  /// Generates a route from the extensions
  /// If it can't find, it falls back to route not found
  ///
  /// It'll also wrap a route with any decorations
  Route onGenerateRoute(settings) {
    try {
      return MaterialPageRoute(
          builder: (ctx) => pageDecorations.reversed.fold(
              routes.where((it) => it.matches(settings)).first.builder(ctx),
              (child, element) => element(ctx, child)));
    } on Exception {
      return MaterialPageRoute(builder: (ctx) => widget.pageNotFoundWidget);
    }
  }

  @override
  List<DartBoardExtension> get extensions => widget.extensions;
}
