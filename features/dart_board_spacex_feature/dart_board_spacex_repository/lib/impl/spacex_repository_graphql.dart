import 'package:graphql/client.dart';

import 'spacex_repository.dart';
import '../generated/graphql_api.dart';

const _ENDPOINT = "https://api.spacex.land/graphql";

const String readPastLaunches = r'''
query GetPastLaunches {
  launchesPast(limit: 1000) {
    mission_name
    launch_date_local
    id
    rocket {
      rocket_name
    }
    links {
      flickr_images
    }
  }
}
''';

const String readRockets = r'''
query GetRockets {
  rockets(limit: 100) {
    active
    company
    name
    cost_per_launch
    boosters
    country
    description
    diameter {
      meters
    }
    engines {
      engine_loss_max
      layout
      number
      propellant_1
      propellant_2
      thrust_to_weight
      type
      version
    }
    first_flight
    height {
      meters
    }
    landing_legs {
      number
      material
    }
    mass {
      kg
    }
    payload_weights {
      kg
    }

    stages
    success_rate_pct
    wikipedia
  }
}
''';

const String readLaunch = r'''
query GetLaunch($id:ID!) {
  launch(id: $id) {
    details
    id
    is_tentative
    launch_date_local
    launch_site {
      site_id
      site_name
      site_name_long
    }
    launch_success
    launch_year
    links {
      article_link
      flickr_images
      mission_patch
      mission_patch_small
      presskit
      reddit_campaign
      reddit_launch
      reddit_media
      reddit_recovery
      video_link
      wikipedia
    }
    mission_id
    mission_name
    rocket {
      rocket_name
    }
    ships {
      name
    }
    telemetry {
      flight_club
    }
    tentative_max_precision
    upcoming
  }
}
''';

class SpaceXRepositoryGraphQL extends SpaceXRepository {
  final _client =
      GraphQLClient(cache: GraphQLCache(), link: HttpLink(_ENDPOINT));

  List<GetPastLaunches$Query$Launch?>? _pastLaunches;
  List<GetRockets$Query$Rocket?>? _rockets;
  Map<String, GetLaunch$Query$Launch?> _launches = {};

  @override
  Future<List<GetPastLaunches$Query$Launch?>> getPastLaunches() async {
    if (_pastLaunches != null) return _pastLaunches!;
    final options = QueryOptions(document: gql(readPastLaunches));
    final result = await _client.query(options);
    return [];
    // _pastLaunches =
    //     (await _client.execute(GetPastLaunchesQuery())).data!.launchesPast;
    // return _pastLaunches!;
  }

  @override
  Future<GetLaunch$Query$Launch?> getLaunchByMissionId(String missionId) async {
    if (_launches.containsKey(missionId)) {
      return _launches[missionId]!;
    }
    /*

    _launches[missionId] = (await _client.execute(
            GetLaunchQuery(variables: GetLaunchArguments(id: missionId))))
        .data
        ?.launch;
    return _launches[missionId]!;
    */
    return null;
  }

  @override
  Future<List<GetRockets$Query$Rocket?>> getRockets() async {
    /*
    if (_rockets != null) return _rockets!;
    _rockets = (await _client.execute(GetRocketsQuery())).data!.rockets!;
    return _rockets!;
    */
    return [];
  }
}
