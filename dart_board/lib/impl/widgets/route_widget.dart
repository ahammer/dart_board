import 'package:dart_board/interface/dart_board_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Route Widget
///
/// Inflates a route if possible and decorates it.
///
/// It delegates to DartBoardCore, this is just the interface
class RouteWidget extends StatelessWidget {
  final RouteSettings settings;

  const RouteWidget({Key? key, required this.settings}) : super(key: key);
  @override
  Widget build(BuildContext context) =>
      Provider.of<DartBoardCore>(context, listen: false).buildPageRoute(
          context,
          settings,
          Provider.of<DartBoardCore>(context, listen: false).routes.firstWhere(
              (it) => it.matches(settings),
              orElse: () => NamedRouteDefinition(
                  builder: (ctx, _) => Text('404'), route: '/404')));
}
