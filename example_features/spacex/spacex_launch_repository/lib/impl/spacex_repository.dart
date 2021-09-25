import 'package:spacex_launch_repository/generated/graphql_api.graphql.dart';

///
abstract class SpaceXRepository {
  Future<List<LaunchData>> getPastLaunches();
}

/// A friendly model to mock easily and abstract GraphQL from UI
class LaunchData {
  final String siteName;
  final String missionName;
  final DateTime launchDateLocal;
  final String rocketName;
  final String articleLink;
  final String videoLink;
  final List<String> flickrImages;

  LaunchData({
    required this.siteName,
    required this.missionName,
    required this.rocketName,
    required this.articleLink,
    required this.videoLink,
    required this.flickrImages,
    required this.launchDateLocal,
  });

  factory LaunchData.fromGql(GetPastLaunches$Query$Launch? e) => LaunchData(
        siteName: e?.launchSite?.siteName ?? "Unknown",
        rocketName: e?.rocket?.rocketName ?? "Rocket Unknown",
        missionName: e?.missionName ?? "Mission Unknown",
        articleLink: e?.links?.articleLink ?? "",
        videoLink: e?.links?.videoLink ?? "",
        launchDateLocal: e?.launchDateLocal ?? DateTime.now(),

        /// Whatever, if this is null I'll use Now() to make it null safe, this won't hit, it's not null in data but I don't want !
        flickrImages:
            e?.links?.flickrImages?.map((e) => e as String).toList() ?? [],
      );
}
