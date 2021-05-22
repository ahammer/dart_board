import 'package:dart_board/dart_board.dart';

/// Route Widget
///
/// Inflates a route if possible and decorates it.
///
/// It delegates to DartBoardCore, this is just the interface
class RouteWidget extends StatelessWidget {
  final bool decorate;
  final RouteSettings settings;

  const RouteWidget({Key? key, required this.settings, this.decorate = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) =>
      Provider.of<DartBoardCore>(context, listen: false).buildPageRoute(
          context,
          settings,
          Provider.of<DartBoardCore>(context, listen: false).routes.firstWhere(
              (it) => it.matches(settings),
              orElse: () => NamedRouteDefinition(
                  builder: (ctx, _) => Text('404'), route: '/404')),
          decorate: decorate);
}
