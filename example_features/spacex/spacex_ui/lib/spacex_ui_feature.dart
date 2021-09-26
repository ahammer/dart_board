import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_locator/dart_board_locator.dart';
import 'package:flutter/material.dart';
import 'package:spacex_launch_repository/impl/spacex_repository.dart';
import 'package:spacex_launch_repository/impl/spacex_repository_graphql.dart';
import 'package:spacex_launch_repository/spacex_data_layer_feature.dart';
import 'ui/launch_screen.dart';

/// Feature with the UI registration
class SpaceXUIFeature extends DartBoardFeature {
  @override
  String get namespace => "spaceXUI";

  @override
  List<RouteDefinition> get routes => [
        PathedRouteDefinition([
          [
            NamedRouteDefinition(
                route: '/launches', builder: (ctx, settings) => LaunchScreen())
          ],
          [UriRoute((ctx, uri) => LaunchDataUriShim(uri: uri))]
        ]),
      ];

  @override
  List<DartBoardFeature> get dependencies => [
        SpaceXDataLayerFeature(SpaceXRepositoryGraphQL()),
        DartBoardLocatorFeature()
      ];
}

class LaunchDataUriShim extends StatelessWidget {
  final Uri uri;

  const LaunchDataUriShim({
    required this.uri,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      LaunchDataScreen(missionName: uri.pathSegments.last);
}

class LaunchDataScreen extends StatefulWidget {
  final String missionName;

  const LaunchDataScreen({Key? key, required this.missionName})
      : super(key: key);

  @override
  State<LaunchDataScreen> createState() => _LaunchDataScreenState();
}

class _LaunchDataScreenState extends State<LaunchDataScreen> {
  late final Future<LaunchData> missionDetailsFuture;

  @override
  void initState() {
    missionDetailsFuture =
        locate<SpaceXRepository>().getLaunchByMissionName(widget.missionName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<LaunchData>(
        future: missionDetailsFuture,
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return LaunchDetailsWidget(data: snapshot.data!);
          }
          return Material(
              child: Center(
            child: SizedBox(
                width: 32, height: 32, child: CircularProgressIndicator()),
          ));
        },
      );
}

class LaunchDetailsWidget extends StatelessWidget {
  final LaunchData data;

  const LaunchDetailsWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(), body: Text(data.missionName));
}
