// GENERATED CODE - DO NOT MODIFY BY HAND
// @dart=2.12

part of 'graphql_api.graphql.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetLaunch$Query$Launch$LaunchSite _$GetLaunch$Query$Launch$LaunchSiteFromJson(
    Map<String, dynamic> json) {
  return GetLaunch$Query$Launch$LaunchSite()
    ..siteId = json['site_id'] as String?
    ..siteName = json['site_name'] as String?
    ..siteNameLong = json['site_name_long'] as String?;
}

Map<String, dynamic> _$GetLaunch$Query$Launch$LaunchSiteToJson(
        GetLaunch$Query$Launch$LaunchSite instance) =>
    <String, dynamic>{
      'site_id': instance.siteId,
      'site_name': instance.siteName,
      'site_name_long': instance.siteNameLong,
    };

GetLaunch$Query$Launch$LaunchLinks _$GetLaunch$Query$Launch$LaunchLinksFromJson(
    Map<String, dynamic> json) {
  return GetLaunch$Query$Launch$LaunchLinks()
    ..articleLink = json['article_link'] as String?
    ..flickrImages = (json['flickr_images'] as List<dynamic>?)
        ?.map((e) => e as String?)
        .toList()
    ..missionPatch = json['mission_patch'] as String?
    ..missionPatchSmall = json['mission_patch_small'] as String?
    ..presskit = json['presskit'] as String?
    ..redditCampaign = json['reddit_campaign'] as String?
    ..redditLaunch = json['reddit_launch'] as String?
    ..redditMedia = json['reddit_media'] as String?
    ..redditRecovery = json['reddit_recovery'] as String?
    ..videoLink = json['video_link'] as String?
    ..wikipedia = json['wikipedia'] as String?;
}

Map<String, dynamic> _$GetLaunch$Query$Launch$LaunchLinksToJson(
        GetLaunch$Query$Launch$LaunchLinks instance) =>
    <String, dynamic>{
      'article_link': instance.articleLink,
      'flickr_images': instance.flickrImages,
      'mission_patch': instance.missionPatch,
      'mission_patch_small': instance.missionPatchSmall,
      'presskit': instance.presskit,
      'reddit_campaign': instance.redditCampaign,
      'reddit_launch': instance.redditLaunch,
      'reddit_media': instance.redditMedia,
      'reddit_recovery': instance.redditRecovery,
      'video_link': instance.videoLink,
      'wikipedia': instance.wikipedia,
    };

GetLaunch$Query$Launch$LaunchRocket
    _$GetLaunch$Query$Launch$LaunchRocketFromJson(Map<String, dynamic> json) {
  return GetLaunch$Query$Launch$LaunchRocket()
    ..rocketName = json['rocket_name'] as String?;
}

Map<String, dynamic> _$GetLaunch$Query$Launch$LaunchRocketToJson(
        GetLaunch$Query$Launch$LaunchRocket instance) =>
    <String, dynamic>{
      'rocket_name': instance.rocketName,
    };

GetLaunch$Query$Launch$Ship _$GetLaunch$Query$Launch$ShipFromJson(
    Map<String, dynamic> json) {
  return GetLaunch$Query$Launch$Ship()..name = json['name'] as String?;
}

Map<String, dynamic> _$GetLaunch$Query$Launch$ShipToJson(
        GetLaunch$Query$Launch$Ship instance) =>
    <String, dynamic>{
      'name': instance.name,
    };

GetLaunch$Query$Launch$LaunchTelemetry
    _$GetLaunch$Query$Launch$LaunchTelemetryFromJson(
        Map<String, dynamic> json) {
  return GetLaunch$Query$Launch$LaunchTelemetry()
    ..flightClub = json['flight_club'] as String?;
}

Map<String, dynamic> _$GetLaunch$Query$Launch$LaunchTelemetryToJson(
        GetLaunch$Query$Launch$LaunchTelemetry instance) =>
    <String, dynamic>{
      'flight_club': instance.flightClub,
    };

GetLaunch$Query$Launch _$GetLaunch$Query$LaunchFromJson(
    Map<String, dynamic> json) {
  return GetLaunch$Query$Launch()
    ..details = json['details'] as String?
    ..id = json['id'] as String?
    ..isTentative = json['is_tentative'] as bool?
    ..launchDateLocal = json['launch_date_local'] == null
        ? null
        : DateTime.parse(json['launch_date_local'] as String)
    ..launchSite = json['launch_site'] == null
        ? null
        : GetLaunch$Query$Launch$LaunchSite.fromJson(
            json['launch_site'] as Map<String, dynamic>)
    ..launchSuccess = json['launch_success'] as bool?
    ..launchYear = json['launch_year'] as String?
    ..links = json['links'] == null
        ? null
        : GetLaunch$Query$Launch$LaunchLinks.fromJson(
            json['links'] as Map<String, dynamic>)
    ..missionId = (json['mission_id'] as List<dynamic>?)
        ?.map((e) => e as String?)
        .toList()
    ..missionName = json['mission_name'] as String?
    ..rocket = json['rocket'] == null
        ? null
        : GetLaunch$Query$Launch$LaunchRocket.fromJson(
            json['rocket'] as Map<String, dynamic>)
    ..ships = (json['ships'] as List<dynamic>?)
        ?.map((e) => e == null
            ? null
            : GetLaunch$Query$Launch$Ship.fromJson(e as Map<String, dynamic>))
        .toList()
    ..telemetry = json['telemetry'] == null
        ? null
        : GetLaunch$Query$Launch$LaunchTelemetry.fromJson(
            json['telemetry'] as Map<String, dynamic>)
    ..tentativeMaxPrecision = json['tentative_max_precision'] as String?
    ..upcoming = json['upcoming'] as bool?;
}

Map<String, dynamic> _$GetLaunch$Query$LaunchToJson(
        GetLaunch$Query$Launch instance) =>
    <String, dynamic>{
      'details': instance.details,
      'id': instance.id,
      'is_tentative': instance.isTentative,
      'launch_date_local': instance.launchDateLocal?.toIso8601String(),
      'launch_site': instance.launchSite?.toJson(),
      'launch_success': instance.launchSuccess,
      'launch_year': instance.launchYear,
      'links': instance.links?.toJson(),
      'mission_id': instance.missionId,
      'mission_name': instance.missionName,
      'rocket': instance.rocket?.toJson(),
      'ships': instance.ships?.map((e) => e?.toJson()).toList(),
      'telemetry': instance.telemetry?.toJson(),
      'tentative_max_precision': instance.tentativeMaxPrecision,
      'upcoming': instance.upcoming,
    };

GetLaunch$Query _$GetLaunch$QueryFromJson(Map<String, dynamic> json) {
  return GetLaunch$Query()
    ..launch = json['launch'] == null
        ? null
        : GetLaunch$Query$Launch.fromJson(
            json['launch'] as Map<String, dynamic>);
}

Map<String, dynamic> _$GetLaunch$QueryToJson(GetLaunch$Query instance) =>
    <String, dynamic>{
      'launch': instance.launch?.toJson(),
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

GetPastLaunches$Query$Launch$LaunchLinks
    _$GetPastLaunches$Query$Launch$LaunchLinksFromJson(
        Map<String, dynamic> json) {
  return GetPastLaunches$Query$Launch$LaunchLinks()
    ..flickrImages = (json['flickr_images'] as List<dynamic>?)
        ?.map((e) => e as String?)
        .toList();
}

Map<String, dynamic> _$GetPastLaunches$Query$Launch$LaunchLinksToJson(
        GetPastLaunches$Query$Launch$LaunchLinks instance) =>
    <String, dynamic>{
      'flickr_images': instance.flickrImages,
    };

GetPastLaunches$Query$Launch _$GetPastLaunches$Query$LaunchFromJson(
    Map<String, dynamic> json) {
  return GetPastLaunches$Query$Launch()
    ..missionName = json['mission_name'] as String?
    ..launchDateLocal = json['launch_date_local'] == null
        ? null
        : DateTime.parse(json['launch_date_local'] as String)
    ..id = json['id'] as String?
    ..rocket = json['rocket'] == null
        ? null
        : GetPastLaunches$Query$Launch$LaunchRocket.fromJson(
            json['rocket'] as Map<String, dynamic>)
    ..links = json['links'] == null
        ? null
        : GetPastLaunches$Query$Launch$LaunchLinks.fromJson(
            json['links'] as Map<String, dynamic>);
}

Map<String, dynamic> _$GetPastLaunches$Query$LaunchToJson(
        GetPastLaunches$Query$Launch instance) =>
    <String, dynamic>{
      'mission_name': instance.missionName,
      'launch_date_local': instance.launchDateLocal?.toIso8601String(),
      'id': instance.id,
      'rocket': instance.rocket?.toJson(),
      'links': instance.links?.toJson(),
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

GetRockets$Query$Rocket$Distance _$GetRockets$Query$Rocket$DistanceFromJson(
    Map<String, dynamic> json) {
  return GetRockets$Query$Rocket$Distance()
    ..meters = (json['meters'] as num?)?.toDouble();
}

Map<String, dynamic> _$GetRockets$Query$Rocket$DistanceToJson(
        GetRockets$Query$Rocket$Distance instance) =>
    <String, dynamic>{
      'meters': instance.meters,
    };

GetRockets$Query$Rocket$RocketEngines
    _$GetRockets$Query$Rocket$RocketEnginesFromJson(Map<String, dynamic> json) {
  return GetRockets$Query$Rocket$RocketEngines()
    ..engineLossMax = json['engine_loss_max'] as String?
    ..layout = json['layout'] as String?
    ..number = json['number'] as int?
    ..propellant1 = json['propellant_1'] as String?
    ..propellant2 = json['propellant_2'] as String?
    ..thrustToWeight = (json['thrust_to_weight'] as num?)?.toDouble()
    ..type = json['type'] as String?
    ..version = json['version'] as String?;
}

Map<String, dynamic> _$GetRockets$Query$Rocket$RocketEnginesToJson(
        GetRockets$Query$Rocket$RocketEngines instance) =>
    <String, dynamic>{
      'engine_loss_max': instance.engineLossMax,
      'layout': instance.layout,
      'number': instance.number,
      'propellant_1': instance.propellant1,
      'propellant_2': instance.propellant2,
      'thrust_to_weight': instance.thrustToWeight,
      'type': instance.type,
      'version': instance.version,
    };

GetRockets$Query$Rocket$RocketLandingLegs
    _$GetRockets$Query$Rocket$RocketLandingLegsFromJson(
        Map<String, dynamic> json) {
  return GetRockets$Query$Rocket$RocketLandingLegs()
    ..number = json['number'] as int?
    ..material = json['material'] as String?;
}

Map<String, dynamic> _$GetRockets$Query$Rocket$RocketLandingLegsToJson(
        GetRockets$Query$Rocket$RocketLandingLegs instance) =>
    <String, dynamic>{
      'number': instance.number,
      'material': instance.material,
    };

GetRockets$Query$Rocket$Mass _$GetRockets$Query$Rocket$MassFromJson(
    Map<String, dynamic> json) {
  return GetRockets$Query$Rocket$Mass()..kg = json['kg'] as int?;
}

Map<String, dynamic> _$GetRockets$Query$Rocket$MassToJson(
        GetRockets$Query$Rocket$Mass instance) =>
    <String, dynamic>{
      'kg': instance.kg,
    };

GetRockets$Query$Rocket$RocketPayloadWeight
    _$GetRockets$Query$Rocket$RocketPayloadWeightFromJson(
        Map<String, dynamic> json) {
  return GetRockets$Query$Rocket$RocketPayloadWeight()..kg = json['kg'] as int?;
}

Map<String, dynamic> _$GetRockets$Query$Rocket$RocketPayloadWeightToJson(
        GetRockets$Query$Rocket$RocketPayloadWeight instance) =>
    <String, dynamic>{
      'kg': instance.kg,
    };

GetRockets$Query$Rocket _$GetRockets$Query$RocketFromJson(
    Map<String, dynamic> json) {
  return GetRockets$Query$Rocket()
    ..active = json['active'] as bool?
    ..company = json['company'] as String?
    ..name = json['name'] as String?
    ..costPerLaunch = json['cost_per_launch'] as int?
    ..boosters = json['boosters'] as int?
    ..country = json['country'] as String?
    ..description = json['description'] as String?
    ..diameter = json['diameter'] == null
        ? null
        : GetRockets$Query$Rocket$Distance.fromJson(
            json['diameter'] as Map<String, dynamic>)
    ..engines = json['engines'] == null
        ? null
        : GetRockets$Query$Rocket$RocketEngines.fromJson(
            json['engines'] as Map<String, dynamic>)
    ..firstFlight = json['first_flight'] == null
        ? null
        : DateTime.parse(json['first_flight'] as String)
    ..height = json['height'] == null
        ? null
        : GetRockets$Query$Rocket$Distance.fromJson(
            json['height'] as Map<String, dynamic>)
    ..landingLegs = json['landing_legs'] == null
        ? null
        : GetRockets$Query$Rocket$RocketLandingLegs.fromJson(
            json['landing_legs'] as Map<String, dynamic>)
    ..mass = json['mass'] == null
        ? null
        : GetRockets$Query$Rocket$Mass.fromJson(
            json['mass'] as Map<String, dynamic>)
    ..payloadWeights = (json['payload_weights'] as List<dynamic>?)
        ?.map((e) => e == null
            ? null
            : GetRockets$Query$Rocket$RocketPayloadWeight.fromJson(
                e as Map<String, dynamic>))
        .toList()
    ..stages = json['stages'] as int?
    ..successRatePct = json['success_rate_pct'] as int?
    ..wikipedia = json['wikipedia'] as String?;
}

Map<String, dynamic> _$GetRockets$Query$RocketToJson(
        GetRockets$Query$Rocket instance) =>
    <String, dynamic>{
      'active': instance.active,
      'company': instance.company,
      'name': instance.name,
      'cost_per_launch': instance.costPerLaunch,
      'boosters': instance.boosters,
      'country': instance.country,
      'description': instance.description,
      'diameter': instance.diameter?.toJson(),
      'engines': instance.engines?.toJson(),
      'first_flight': instance.firstFlight?.toIso8601String(),
      'height': instance.height?.toJson(),
      'landing_legs': instance.landingLegs?.toJson(),
      'mass': instance.mass?.toJson(),
      'payload_weights':
          instance.payloadWeights?.map((e) => e?.toJson()).toList(),
      'stages': instance.stages,
      'success_rate_pct': instance.successRatePct,
      'wikipedia': instance.wikipedia,
    };

GetRockets$Query _$GetRockets$QueryFromJson(Map<String, dynamic> json) {
  return GetRockets$Query()
    ..rockets = (json['rockets'] as List<dynamic>?)
        ?.map((e) => e == null
            ? null
            : GetRockets$Query$Rocket.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$GetRockets$QueryToJson(GetRockets$Query instance) =>
    <String, dynamic>{
      'rockets': instance.rockets?.map((e) => e?.toJson()).toList(),
    };

GetLaunchArguments _$GetLaunchArgumentsFromJson(Map<String, dynamic> json) {
  return GetLaunchArguments(
    id: json['id'] as String,
  );
}

Map<String, dynamic> _$GetLaunchArgumentsToJson(GetLaunchArguments instance) =>
    <String, dynamic>{
      'id': instance.id,
    };
