// GENERATED CODE - DO NOT MODIFY BY HAND
// @dart=2.12

part of 'graphql_api.graphql.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetPastLaunches$Query$Launch$LaunchSite
    _$GetPastLaunches$Query$Launch$LaunchSiteFromJson(
        Map<String, dynamic> json) {
  return GetPastLaunches$Query$Launch$LaunchSite()
    ..siteName = json['site_name'] as String?;
}

Map<String, dynamic> _$GetPastLaunches$Query$Launch$LaunchSiteToJson(
        GetPastLaunches$Query$Launch$LaunchSite instance) =>
    <String, dynamic>{
      'site_name': instance.siteName,
    };

GetPastLaunches$Query$Launch$LaunchLinks
    _$GetPastLaunches$Query$Launch$LaunchLinksFromJson(
        Map<String, dynamic> json) {
  return GetPastLaunches$Query$Launch$LaunchLinks()
    ..articleLink = json['article_link'] as String?
    ..videoLink = json['video_link'] as String?
    ..flickrImages = (json['flickr_images'] as List<dynamic>?)
        ?.map((e) => e as String?)
        .toList();
}

Map<String, dynamic> _$GetPastLaunches$Query$Launch$LaunchLinksToJson(
        GetPastLaunches$Query$Launch$LaunchLinks instance) =>
    <String, dynamic>{
      'article_link': instance.articleLink,
      'video_link': instance.videoLink,
      'flickr_images': instance.flickrImages,
    };

GetPastLaunches$Query$Launch$LaunchRocket
    _$GetPastLaunches$Query$Launch$LaunchRocketFromJson(
        Map<String, dynamic> json) {
  return GetPastLaunches$Query$Launch$LaunchRocket()
    ..rocketName = json['rocket_name'] as String?;
}

Map<String, dynamic> _$GetPastLaunches$Query$Launch$LaunchRocketToJson(
        GetPastLaunches$Query$Launch$LaunchRocket instance) =>
    <String, dynamic>{
      'rocket_name': instance.rocketName,
    };

GetPastLaunches$Query$Launch$Ship _$GetPastLaunches$Query$Launch$ShipFromJson(
    Map<String, dynamic> json) {
  return GetPastLaunches$Query$Launch$Ship()
    ..name = json['name'] as String?
    ..homePort = json['home_port'] as String?
    ..image = json['image'] as String?;
}

Map<String, dynamic> _$GetPastLaunches$Query$Launch$ShipToJson(
        GetPastLaunches$Query$Launch$Ship instance) =>
    <String, dynamic>{
      'name': instance.name,
      'home_port': instance.homePort,
      'image': instance.image,
    };

GetPastLaunches$Query$Launch _$GetPastLaunches$Query$LaunchFromJson(
    Map<String, dynamic> json) {
  return GetPastLaunches$Query$Launch()
    ..missionName = json['mission_name'] as String?
    ..launchDateLocal = json['launch_date_local'] == null
        ? null
        : DateTime.parse(json['launch_date_local'] as String)
    ..launchSite = json['launch_site'] == null
        ? null
        : GetPastLaunches$Query$Launch$LaunchSite.fromJson(
            json['launch_site'] as Map<String, dynamic>)
    ..links = json['links'] == null
        ? null
        : GetPastLaunches$Query$Launch$LaunchLinks.fromJson(
            json['links'] as Map<String, dynamic>)
    ..rocket = json['rocket'] == null
        ? null
        : GetPastLaunches$Query$Launch$LaunchRocket.fromJson(
            json['rocket'] as Map<String, dynamic>)
    ..ships = (json['ships'] as List<dynamic>?)
        ?.map((e) => e == null
            ? null
            : GetPastLaunches$Query$Launch$Ship.fromJson(
                e as Map<String, dynamic>))
        .toList()
    ..missionId = (json['mission_id'] as List<dynamic>?)
        ?.map((e) => e as String?)
        .toList();
}

Map<String, dynamic> _$GetPastLaunches$Query$LaunchToJson(
        GetPastLaunches$Query$Launch instance) =>
    <String, dynamic>{
      'mission_name': instance.missionName,
      'launch_date_local': instance.launchDateLocal?.toIso8601String(),
      'launch_site': instance.launchSite?.toJson(),
      'links': instance.links?.toJson(),
      'rocket': instance.rocket?.toJson(),
      'ships': instance.ships?.map((e) => e?.toJson()).toList(),
      'mission_id': instance.missionId,
    };

GetPastLaunches$Query _$GetPastLaunches$QueryFromJson(
    Map<String, dynamic> json) {
  return GetPastLaunches$Query()
    ..launchesPast = (json['launchesPast'] as List<dynamic>?)
        ?.map((e) => e == null
            ? null
            : GetPastLaunches$Query$Launch.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$GetPastLaunches$QueryToJson(
        GetPastLaunches$Query instance) =>
    <String, dynamic>{
      'launchesPast': instance.launchesPast?.map((e) => e?.toJson()).toList(),
    };
