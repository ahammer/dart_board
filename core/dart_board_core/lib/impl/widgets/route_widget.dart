import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_core/impl/widgets/route_not_found.dart';

/// Route Widget
///
/// Inflates a route if possible and decorates it.
///
/// It delegates to DartBoardCore, this is just the interface
class RouteWidget extends StatelessWidget {
  final bool decorate;
  final RouteSettings settings;

  const RouteWidget._internal(
      {Key? key, required this.settings, this.decorate = false})
      : super(key: key);

  factory RouteWidget(String initialRoute,
          {dynamic args, bool decorate = false, Key? key}) =>
      RouteWidget._internal(
          settings: RouteSettings(name: initialRoute, arguments: args),
          decorate: decorate,
          key: key);

  @override
  Widget build(BuildContext context) =>
      Provider.of<DartBoardCore>(context, listen: false).buildPageRoute(
          context,
          settings,
          Provider.of<DartBoardCore>(context, listen: false).routes.firstWhere(
              (it) => it.matches(settings),
              orElse: () => NamedRouteDefinition(
                  builder: (ctx, _) => RouteNotFound(settings.name!),
                  route: '/404')),
          decorate: decorate);
}
