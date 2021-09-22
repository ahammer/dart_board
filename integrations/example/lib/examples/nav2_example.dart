import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_core/impl/route_types/pathed_route.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(DartBoard(features: [Nav2Feature()], initialRoute: '/Root'));
}

class Nav2Feature extends DartBoardFeature {
  @override
  String get namespace => 'nav2';

  @override
  List<RouteDefinition> get routes => [PathedRouteDefinition()];
}
