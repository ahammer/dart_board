import 'package:dart_board_core/dart_board.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(DartBoard(features: [Nav2Feature()], initialroute: 'root/cata'));
}

class Nav2Feature extends DartBoardFeature {
  @override
  String get namespace => 'nav2';

  @override
  List<RouteDefinition> get routes => [PathedRouteDefinition()];
}
