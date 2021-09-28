// GENERATED CODE - DO NOT MODIFY BY HAND
// @dart = 2.12

import 'package:artemis/artemis.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'package:gql/ast.dart';
part 'graphql_api.graphql.g.dart';

@JsonSerializable(explicitToJson: true)
class GetPastLaunches$Query$Launch$LaunchSite extends JsonSerializable
    with EquatableMixin {
  GetPastLaunches$Query$Launch$LaunchSite();

  factory GetPastLaunches$Query$Launch$LaunchSite.fromJson(
          Map<String, dynamic> json) =>
      _$GetPastLaunches$Query$Launch$LaunchSiteFromJson(json);

  @JsonKey(name: 'site_name')
  String? siteName;

  @override
  List<Object?> get props => [siteName];
  @override
  Map<String, dynamic> toJson() =>
      _$GetPastLaunches$Query$Launch$LaunchSiteToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GetPastLaunches$Query$Launch$LaunchLinks extends JsonSerializable
    with EquatableMixin {
  GetPastLaunches$Query$Launch$LaunchLinks();

  factory GetPastLaunches$Query$Launch$LaunchLinks.fromJson(
          Map<String, dynamic> json) =>
      _$GetPastLaunches$Query$Launch$LaunchLinksFromJson(json);

  @JsonKey(name: 'article_link')
  String? articleLink;

  @JsonKey(name: 'video_link')
  String? videoLink;

  @JsonKey(name: 'flickr_images')
  List<String?>? flickrImages;

  @override
  List<Object?> get props => [articleLink, videoLink, flickrImages];
  @override
  Map<String, dynamic> toJson() =>
      _$GetPastLaunches$Query$Launch$LaunchLinksToJson(this);
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
class GetPastLaunches$Query$Launch$Ship extends JsonSerializable
    with EquatableMixin {
  GetPastLaunches$Query$Launch$Ship();

  factory GetPastLaunches$Query$Launch$Ship.fromJson(
          Map<String, dynamic> json) =>
      _$GetPastLaunches$Query$Launch$ShipFromJson(json);

  String? name;

  @JsonKey(name: 'home_port')
  String? homePort;

  String? image;

  @override
  List<Object?> get props => [name, homePort, image];
  @override
  Map<String, dynamic> toJson() =>
      _$GetPastLaunches$Query$Launch$ShipToJson(this);
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

  @JsonKey(name: 'launch_site')
  GetPastLaunches$Query$Launch$LaunchSite? launchSite;

  GetPastLaunches$Query$Launch$LaunchLinks? links;

  GetPastLaunches$Query$Launch$LaunchRocket? rocket;

  List<GetPastLaunches$Query$Launch$Ship?>? ships;

  @JsonKey(name: 'mission_id')
  List<String?>? missionId;

  @override
  List<Object?> get props => [
        missionName,
        launchDateLocal,
        launchSite,
        links,
        rocket,
        ships,
        missionId
      ];
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
                  value: IntValueNode(value: '100'))
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
                  name: NameNode(value: 'launch_site'),
                  alias: null,
                  arguments: [],
                  directives: [],
                  selectionSet: SelectionSetNode(selections: [
                    FieldNode(
                        name: NameNode(value: 'site_name'),
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
                        name: NameNode(value: 'article_link'),
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
                        name: NameNode(value: 'flickr_images'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null)
                  ])),
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
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'home_port'),
                        alias: null,
                        arguments: [],
                        directives: [],
                        selectionSet: null),
                    FieldNode(
                        name: NameNode(value: 'image'),
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
                  selectionSet: null)
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
