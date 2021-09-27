import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_locator/dart_board_locator.dart';
import 'package:flutter/material.dart';
import 'package:spacex_launch_repository/impl/spacex_repository.dart';
import 'package:spacex_launch_repository/impl/spacex_repository_graphql.dart';
import 'package:spacex_launch_repository/spacex_data_layer_feature.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';
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
          return Scaffold(
            appBar: AppBar(title: Text(widget.missionName)),
            body: Center(
              child: SizedBox(
                  width: 128, height: 128, child: CircularProgressIndicator()),
            ),
          );
        },
      );
}

class LaunchDetailsWidget extends StatelessWidget {
  final LaunchData data;

  const LaunchDetailsWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(data.missionName),
      ),
      body: CustomScrollView(
        slivers: [
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400.0,
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 0.0,
              childAspectRatio: 5.0,
            ),
            delegate: SliverChildListDelegate.fixed([
              Card(child: Center(child: Text(data.rocketName))),
              Card(
                  child: Center(
                      child: Text(data.launchDateLocal.toIso8601String()))),
              Card(child: Center(child: Text(data.siteName))),
              if (data.videoLink.isNotEmpty)
                Card(
                    child: InkWell(
                        onTap: () => launch(data.videoLink),
                        child: Center(child: Text('Youtube')))),
              if (data.articleLink.isNotEmpty)
                Card(
                    child: InkWell(
                        onTap: () => launch(data.articleLink),
                        child: Center(child: Text('Article')))),
            ]),
          ),
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 400.0,
              mainAxisSpacing: 0.0,
              crossAxisSpacing: 0.0,
              childAspectRatio: 1.0,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    clipBehavior: Clip.antiAlias,
                    child: FadeInImage.memoryNetwork(
                        fit: BoxFit.cover,
                        placeholder: kTransparentImage,
                        image: data.flickrImages[index]));
              },
              childCount: data.flickrImages.length,
            ),
          )
        ],
      ));
}
