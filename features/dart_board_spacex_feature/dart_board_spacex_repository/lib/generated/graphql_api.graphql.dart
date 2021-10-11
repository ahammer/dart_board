// GENERATED CODE - DO NOT MODIFY BY HAND
// @dart = 2.12

import 'package:artemis/artemis.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:gql/ast.dart';
part 'graphql_api.graphql.g.dart';

@JsonSerializable(explicitToJson: true)
class GetLaunch$Query$Launch$LaunchSite extends JsonSerializable
    with EquatableMixin {
  GetLaunch$Query$Launch$LaunchSite();

  factory GetLaunch$Query$Launch$LaunchSite.fromJson(
          Map<String, dynamic> json) =>
      _$GetLaunch$Query$Launch$LaunchSiteFromJson(json);

  @JsonKey(name: 'site_id')
  String? siteId;

  @JsonKey(name: 'site_name')
  String? siteName;

  @JsonKey(name: 'site_name_long')
  String? siteNameLong;

  @override
  List<Object?> get props => [siteId, siteName, siteNameLong];
  @override
  Map<String, dynamic> toJson() =>
      _$GetLaunch$Query$Launch$LaunchSiteToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetLaunch$Query$Launch$LaunchLinks extends JsonSerializable
    with EquatableMixin {
  GetLaunch$Query$Launch$LaunchLinks();

  factory GetLaunch$Query$Launch$LaunchLinks.fromJson(
          Map<String, dynamic> json) =>
      _$GetLaunch$Query$Launch$LaunchLinksFromJson(json);

  @JsonKey(name: 'article_link')
  String? articleLink;

  @JsonKey(name: 'flickr_images')
  List<String?>? flickrImages;

  @JsonKey(name: 'mission_patch')
  String? missionPatch;

  @JsonKey(name: 'mission_patch_small')
  String? missionPatchSmall;

  String? presskit;

  @JsonKey(name: 'reddit_campaign')
  String? redditCampaign;

  @JsonKey(name: 'reddit_launch')
  String? redditLaunch;

  @JsonKey(name: 'reddit_media')
  String? redditMedia;

  @JsonKey(name: 'reddit_recovery')
  String? redditRecovery;

  @JsonKey(name: 'video_link')
  String? videoLink;

  String? wikipedia;

  @override
  List<Object?> get props => [
        articleLink,
        flickrImages,
        missionPatch,
        missionPatchSmall,
        presskit,
        redditCampaign,
        redditLaunch,
        redditMedia,
        redditRecovery,
        videoLink,
        wikipedia
      ];
  @override
  Map<String, dynamic> toJson() =>
      _$GetLaunch$Query$Launch$LaunchLinksToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetLaunch$Query$Launch$LaunchRocket extends JsonSerializable
    with EquatableMixin {
  GetLaunch$Query$Launch$LaunchRocket();

  factory GetLaunch$Query$Launch$LaunchRocket.fromJson(
          Map<String, dynamic> json) =>
      _$GetLaunch$Query$Launch$LaunchRocketFromJson(json);

  @JsonKey(name: 'rocket_name')
  String? rocketName;

  @override
  List<Object?> get props => [rocketName];
  @override
  Map<String, dynamic> toJson() =>
      _$GetLaunch$Query$Launch$LaunchRocketToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetLaunch$Query$Launch$Ship extends JsonSerializable with EquatableMixin {
  GetLaunch$Query$Launch$Ship();

  factory GetLaunch$Query$Launch$Ship.fromJson(Map<String, dynamic> json) =>
      _$GetLaunch$Query$Launch$ShipFromJson(json);

  String? name;

  @override
  List<Object?> get props => [name];
  @override
  Map<String, dynamic> toJson() => _$GetLaunch$Query$Launch$ShipToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetLaunch$Query$Launch$LaunchTelemetry extends JsonSerializable
    with EquatableMixin {
  GetLaunch$Query$Launch$LaunchTelemetry();

  factory GetLaunch$Query$Launch$LaunchTelemetry.fromJson(
          Map<String, dynamic> json) =>
      _$GetLaunch$Query$Launch$LaunchTelemetryFromJson(json);

  @JsonKey(name: 'flight_club')
  String? flightClub;

  @override
  List<Object?> get props => [flightClub];
  @override
  Map<String, dynamic> toJson() =>
      _$GetLaunch$Query$Launch$LaunchTelemetryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetLaunch$Query$Launch extends JsonSerializable with EquatableMixin {
  GetLaunch$Query$Launch();

  factory GetLaunch$Query$Launch.fromJson(Map<String, dynamic> json) =>
      _$GetLaunch$Query$LaunchFromJson(json);

  String? details;

  String? id;

  @JsonKey(name: 'is_tentative')
  bool? isTentative;

  @JsonKey(name: 'launch_date_local')
  DateTime? launchDateLocal;

  @JsonKey(name: 'launch_site')
  GetLaunch$Query$Launch$LaunchSite? launchSite;

  @JsonKey(name: 'launch_success')
  bool? launchSuccess;

  @JsonKey(name: 'launch_year')
  String? launchYear;

  GetLaunch$Query$Launch$LaunchLinks? links;

  @JsonKey(name: 'mission_id')
  List<String?>? missionId;

  @JsonKey(name: 'mission_name')
  String? missionName;

  GetLaunch$Query$Launch$LaunchRocket? rocket;

  List<GetLaunch$Query$Launch$Ship?>? ships;

  GetLaunch$Query$Launch$LaunchTelemetry? telemetry;

  @JsonKey(name: 'tentative_max_precision')
  String? tentativeMaxPrecision;

  bool? upcoming;

  @override
  List<Object?> get props => [
        details,
        id,
        isTentative,
        launchDateLocal,
        launchSite,
        launchSuccess,
        launchYear,
        links,
        missionId,
        missionName,
        rocket,
        ships,
        telemetry,
        tentativeMaxPrecision,
        upcoming
      ];
  @override
  Map<String, dynamic> toJson() => _$GetLaunch$Query$LaunchToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetLaunch$Query extends JsonSerializable with EquatableMixin {
  GetLaunch$Query();

  factory GetLaunch$Query.fromJson(Map<String, dynamic> json) =>
      _$GetLaunch$QueryFromJson(json);

  GetLaunch$Query$Launch? launch;

  @override
  List<Object?> get props => [launch];
  @override
  Map<String, dynamic> toJson() => _$GetLaunch$QueryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetPastLaunches$Query$Launch$LaunchRocket extends JsonSerializable
    with EquatableMixin {
  GetPastLaunches$Query$Launch$LaunchRocket();

  factory GetPastLaunches$Query$Launch$LaunchRocket.fromJson(
          Map<String, dynamic> json) =>
      _$GetPastLaunches$Query$Launch$LaunchRocketFromJson(json);

  @JsonKey(name: 'rocket_name')
  String? rocketName;

  @override
  List<Object?> get props => [rocketName];
  @override
  Map<String, dynamic> toJson() =>
      _$GetPastLaunches$Query$Launch$LaunchRocketToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetPastLaunches$Query$Launch$LaunchLinks extends JsonSerializable
    with EquatableMixin {
  GetPastLaunches$Query$Launch$LaunchLinks();

  factory GetPastLaunches$Query$Launch$LaunchLinks.fromJson(
          Map<String, dynamic> json) =>
      _$GetPastLaunches$Query$Launch$LaunchLinksFromJson(json);

  @JsonKey(name: 'flickr_images')
  List<String?>? flickrImages;

  @override
  List<Object?> get props => [flickrImages];
  @override
  Map<String, dynamic> toJson() =>
      _$GetPastLaunches$Query$Launch$LaunchLinksToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetPastLaunches$Query$Launch extends JsonSerializable
    with EquatableMixin {
  GetPastLaunches$Query$Launch();

  factory GetPastLaunches$Query$Launch.fromJson(Map<String, dynamic> json) =>
      _$GetPastLaunches$Query$LaunchFromJson(json);

  @JsonKey(name: 'mission_name')
  String? missionName;

  @JsonKey(name: 'launch_date_local')
  DateTime? launchDateLocal;

  String? id;

  GetPastLaunches$Query$Launch$LaunchRocket? rocket;

  GetPastLaunches$Query$Launch$LaunchLinks? links;

  @override
  List<Object?> get props => [missionName, launchDateLocal, id, rocket, links];
  @override
  Map<String, dynamic> toJson() => _$GetPastLaunches$Query$LaunchToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetPastLaunches$Query extends JsonSerializable with EquatableMixin {
  GetPastLaunches$Query();

  factory GetPastLaunches$Query.fromJson(Map<String, dynamic> json) =>
      _$GetPastLaunches$QueryFromJson(json);

  List<GetPastLaunches$Query$Launch?>? launchesPast;

  @override
  List<Object?> get props => [launchesPast];
  @override
  Map<String, dynamic> toJson() => _$GetPastLaunches$QueryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetRockets$Query$Rocket$Distance extends JsonSerializable
    with EquatableMixin {
  GetRockets$Query$Rocket$Distance();

  factory GetRockets$Query$Rocket$Distance.fromJson(
          Map<String, dynamic> json) =>
      _$GetRockets$Query$Rocket$DistanceFromJson(json);

  double? meters;

  @override
  List<Object?> get props => [meters];
  @override
  Map<String, dynamic> toJson() =>
      _$GetRockets$Query$Rocket$DistanceToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetRockets$Query$Rocket$RocketEngines extends JsonSerializable
    with EquatableMixin {
  GetRockets$Query$Rocket$RocketEngines();

  factory GetRockets$Query$Rocket$RocketEngines.fromJson(
          Map<String, dynamic> json) =>
      _$GetRockets$Query$Rocket$RocketEnginesFromJson(json);

  @JsonKey(name: 'engine_loss_max')
  String? engineLossMax;

  String? layout;

  int? number;

  @JsonKey(name: 'propellant_1')
  String? propellant1;

  @JsonKey(name: 'propellant_2')
  String? propellant2;

  @JsonKey(name: 'thrust_to_weight')
  double? thrustToWeight;

  String? type;

  String? version;

  @override
  List<Object?> get props => [
        engineLossMax,
        layout,
        number,
        propellant1,
        propellant2,
        thrustToWeight,
        type,
        version
      ];
  @override
  Map<String, dynamic> toJson() =>
      _$GetRockets$Query$Rocket$RocketEnginesToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetRockets$Query$Rocket$RocketLandingLegs extends JsonSerializable
    with EquatableMixin {
  GetRockets$Query$Rocket$RocketLandingLegs();

  factory GetRockets$Query$Rocket$RocketLandingLegs.fromJson(
          Map<String, dynamic> json) =>
      _$GetRockets$Query$Rocket$RocketLandingLegsFromJson(json);

  int? number;

  String? material;

  @override
  List<Object?> get props => [number, material];
  @override
  Map<String, dynamic> toJson() =>
      _$GetRockets$Query$Rocket$RocketLandingLegsToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetRockets$Query$Rocket$Mass extends JsonSerializable
    with EquatableMixin {
  GetRockets$Query$Rocket$Mass();

  factory GetRockets$Query$Rocket$Mass.fromJson(Map<String, dynamic> json) =>
      _$GetRockets$Query$Rocket$MassFromJson(json);

  int? kg;

  @override
  List<Object?> get props => [kg];
  @override
  Map<String, dynamic> toJson() => _$GetRockets$Query$Rocket$MassToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetRockets$Query$Rocket$RocketPayloadWeight extends JsonSerializable
    with EquatableMixin {
  GetRockets$Query$Rocket$RocketPayloadWeight();

  factory GetRockets$Query$Rocket$RocketPayloadWeight.fromJson(
          Map<String, dynamic> json) =>
      _$GetRockets$Query$Rocket$RocketPayloadWeightFromJson(json);

  int? kg;

  @override
  List<Object?> get props => [kg];
  @override
  Map<String, dynamic> toJson() =>
      _$GetRockets$Query$Rocket$RocketPayloadWeightToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetRockets$Query$Rocket extends JsonSerializable with EquatableMixin {
  GetRockets$Query$Rocket();

  factory GetRockets$Query$Rocket.fromJson(Map<String, dynamic> json) =>
      _$GetRockets$Query$RocketFromJson(json);

  bool? active;

  String? company;

  String? name;

  @JsonKey(name: 'cost_per_launch')
  int? costPerLaunch;

  int? boosters;

  String? country;

  String? description;

  GetRockets$Query$Rocket$Distance? diameter;

  GetRockets$Query$Rocket$RocketEngines? engines;

  @JsonKey(name: 'first_flight')
  DateTime? firstFlight;

  GetRockets$Query$Rocket$Distance? height;

  @JsonKey(name: 'landing_legs')
  GetRockets$Query$Rocket$RocketLandingLegs? landingLegs;

  GetRockets$Query$Rocket$Mass? mass;

  @JsonKey(name: 'payload_weights')
  List<GetRockets$Query$Rocket$RocketPayloadWeight?>? payloadWeights;

  int? stages;

  @JsonKey(name: 'success_rate_pct')
  int? successRatePct;

  String? wikipedia;

  @override
  List<Object?> get props => [
        active,
        company,
        name,
        costPerLaunch,
        boosters,
        country,
        description,
        diameter,
        engines,
        firstFlight,
        height,
        landingLegs,
        mass,
        payloadWeights,
        stages,
        successRatePct,
        wikipedia
      ];
  @override
  Map<String, dynamic> toJson() => _$GetRockets$Query$RocketToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetRockets$Query extends JsonSerializable with EquatableMixin {
  GetRockets$Query();

  factory GetRockets$Query.fromJson(Map<String, dynamic> json) =>
      _$GetRockets$QueryFromJson(json);

  List<GetRockets$Query$Rocket?>? rockets;

  @override
  List<Object?> get props => [rockets];
  @override
  Map<String, dynamic> toJson() => _$GetRockets$QueryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetLaunchArguments extends JsonSerializable with EquatableMixin {
  GetLaunchArguments({required this.id});

  @override
  factory GetLaunchArguments.fromJson(Map<String, dynamic> json) =>
      _$GetLaunchArgumentsFromJson(json);

  late String id;

  @override
  List<Object?> get props => [id];
  @override
  Map<String, dynamic> toJson() => _$GetLaunchArgumentsToJson(this);
}

final GET_LAUNCH_QUERY_DOCUMENT = DocumentNode(definitions: [
  OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'GetLaunch'),
      variableDefinitions: [
        VariableDefinitionNode(
            variable: VariableNode(name: NameNode(value: 'id')),
            type: NamedTypeNode(name: NameNode(value: 'ID'), isNonNull: true),
            defaultValue: DefaultValueNode(value: null),
            directives: [])
      ],
      directives: [],
      selectionSet: SelectionSetNode(selections: [
        FieldNode(
            name: NameNode(value: 'launch'),
            alias: null,
            arguments: [
              ArgumentNode(
                  name: NameNode(value: 'id'),
                  value: VariableNode(name: NameNode(value: 'id')))
            ],
            directives: [],
            selectionSet: SelectionSetNode(selections: [
              FieldNode(
                  name: NameNode(value: 'details'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'id'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'is_tentative'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'launch_date_local'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'launch_site'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
                    FieldNode(
                        name: NameNode(value: 'site_id'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'site_name'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'site_name_long'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null)
                  ])),
              FieldNode(
                  name: NameNode(value: 'launch_success'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'launch_year'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'links'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
                    FieldNode(
                        name: NameNode(value: 'article_link'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'flickr_images'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'mission_patch'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'mission_patch_small'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'presskit'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'reddit_campaign'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'reddit_launch'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'reddit_media'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'reddit_recovery'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'video_link'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'wikipedia'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null)
                  ])),
              FieldNode(
                  name: NameNode(value: 'mission_id'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'mission_name'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'rocket'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
                    FieldNode(
                        name: NameNode(value: 'rocket_name'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null)
                  ])),
              FieldNode(
                  name: NameNode(value: 'ships'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
                    FieldNode(
                        name: NameNode(value: 'name'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null)
                  ])),
              FieldNode(
                  name: NameNode(value: 'telemetry'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
                    FieldNode(
                        name: NameNode(value: 'flight_club'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null)
                  ])),
              FieldNode(
                  name: NameNode(value: 'tentative_max_precision'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'upcoming'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null)
            ]))
      ]))
]);

class GetLaunchQuery extends GraphQLQuery<GetLaunch$Query, GetLaunchArguments> {
  GetLaunchQuery({required this.variables});

  @override
  final DocumentNode document = GET_LAUNCH_QUERY_DOCUMENT;

  @override
  final String operationName = 'GetLaunch';

  @override
  final GetLaunchArguments variables;

  @override
  List<Object?> get props => [document, operationName, variables];
  @override
  GetLaunch$Query parse(Map<String, dynamic> json) =>
      GetLaunch$Query.fromJson(json);
}

final GET_PAST_LAUNCHES_QUERY_DOCUMENT = DocumentNode(definitions: [
  OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'GetPastLaunches'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(selections: [
        FieldNode(
            name: NameNode(value: 'launchesPast'),
            alias: null,
            arguments: [
              ArgumentNode(
                  name: NameNode(value: 'limit'),
                  value: IntValueNode(value: '1000'))
            ],
            directives: [],
            selectionSet: SelectionSetNode(selections: [
              FieldNode(
                  name: NameNode(value: 'mission_name'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'launch_date_local'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'id'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'rocket'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
                    FieldNode(
                        name: NameNode(value: 'rocket_name'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null)
                  ])),
              FieldNode(
                  name: NameNode(value: 'links'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
                    FieldNode(
                        name: NameNode(value: 'flickr_images'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null)
                  ]))
            ]))
      ]))
]);

class GetPastLaunchesQuery
    extends GraphQLQuery<GetPastLaunches$Query, JsonSerializable> {
  GetPastLaunchesQuery();

  @override
  final DocumentNode document = GET_PAST_LAUNCHES_QUERY_DOCUMENT;

  @override
  final String operationName = 'GetPastLaunches';

  @override
  List<Object?> get props => [document, operationName];
  @override
  GetPastLaunches$Query parse(Map<String, dynamic> json) =>
      GetPastLaunches$Query.fromJson(json);
}

final GET_ROCKETS_QUERY_DOCUMENT = DocumentNode(definitions: [
  OperationDefinitionNode(
      type: OperationType.query,
      name: NameNode(value: 'GetRockets'),
      variableDefinitions: [],
      directives: [],
      selectionSet: SelectionSetNode(selections: [
        FieldNode(
            name: NameNode(value: 'rockets'),
            alias: null,
            arguments: [
              ArgumentNode(
                  name: NameNode(value: 'limit'),
                  value: IntValueNode(value: '100'))
            ],
            directives: [],
            selectionSet: SelectionSetNode(selections: [
              FieldNode(
                  name: NameNode(value: 'active'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'company'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'name'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'cost_per_launch'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'boosters'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'country'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'description'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'diameter'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
                    FieldNode(
                        name: NameNode(value: 'meters'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null)
                  ])),
              FieldNode(
                  name: NameNode(value: 'engines'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
                    FieldNode(
                        name: NameNode(value: 'engine_loss_max'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'layout'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'number'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'propellant_1'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'propellant_2'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'thrust_to_weight'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'type'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'version'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null)
                  ])),
              FieldNode(
                  name: NameNode(value: 'first_flight'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'height'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
                    FieldNode(
                        name: NameNode(value: 'meters'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null)
                  ])),
              FieldNode(
                  name: NameNode(value: 'landing_legs'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
                    FieldNode(
                        name: NameNode(value: 'number'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'material'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null)
                  ])),
              FieldNode(
                  name: NameNode(value: 'mass'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
                    FieldNode(
                        name: NameNode(value: 'kg'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null)
                  ])),
              FieldNode(
                  name: NameNode(value: 'payload_weights'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
                    FieldNode(
                        name: NameNode(value: 'kg'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null)
                  ])),
              FieldNode(
                  name: NameNode(value: 'stages'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'success_rate_pct'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null),
              FieldNode(
                  name: NameNode(value: 'wikipedia'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: null)
            ]))
      ]))
]);

class GetRocketsQuery extends GraphQLQuery<GetRockets$Query, JsonSerializable> {
  GetRocketsQuery();

  @override
  final DocumentNode document = GET_ROCKETS_QUERY_DOCUMENT;

  @override
  final String operationName = 'GetRockets';

  @override
  List<Object?> get props => [document, operationName];
  @override
  GetRockets$Query parse(Map<String, dynamic> json) =>
      GetRockets$Query.fromJson(json);
}
