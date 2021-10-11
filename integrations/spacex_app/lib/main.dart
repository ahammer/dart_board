import 'dart:io';

import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_space_scene/space_scene_feature.dart';
import 'package:dart_board_spacex_repository/impl/spacex_repository.dart';
import 'package:dart_board_theme/dart_board_theme.dart';
import 'package:flutter/material.dart';
import 'package:dart_board_spacex_ui/spacex_ui_feature.dart';
import 'package:dart_board_locator/dart_board_locator.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(DartBoard(
    features: [
      SpaceXUIFeature(),
      SpaceSceneFeature(),
      ThemeFeature(data: ThemeData.dark()),
      EntryPoint(),
    ],
    initialPath: '/entry_point',
  ));
}

class EntryPoint extends DartBoardFeature {
  @override
  String get namespace => "SpaceXEntryPoint";

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: '/entry_point',
            builder: (ctx, settings) => Scaffold(
                  body: Center(
                      child: MaterialButton(
                          elevation: 2,
                          onPressed: () {
                            DartBoardCore.nav.push('/launches');
                          },
                          child: WidgetStream((ctx) async* {
                            yield Text('Loading...');
                            final repository = locate<SpaceXRepository>();
                            final pastLaunches =
                                await repository.getPastLaunches();
                            yield Text("${pastLaunches.length} Launches");
                            final rockets = await repository.getRockets();
                            yield Text(
                                "${pastLaunches.length} Launches\n${rockets.length} Rockets");
                          }))),
                ))
      ];
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
