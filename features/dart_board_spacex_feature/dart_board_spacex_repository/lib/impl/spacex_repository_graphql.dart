import 'package:artemis/artemis.dart';

import 'spacex_repository.dart';
import '../generated/graphql_api.dart';

const _ENDPOINT = "https://api.spacex.land/graphql";

class SpaceXRepositoryGraphQL extends SpaceXRepository {
  final _client = ArtemisClient(_ENDPOINT);

  List<GetPastLaunches$Query$Launch?>? _pastLaunches;
  List<GetRockets$Query$Rocket?>? _rockets;
  Map<String, GetLaunch$Query$Launch?> _launches = {};

  @override
  Future<List<GetPastLaunches$Query$Launch?>> getPastLaunches() async {
    if (_pastLaunches != null) return _pastLaunches!;
    _pastLaunches =
        (await _client.execute(GetPastLaunchesQuery())).data!.launchesPast;
    return _pastLaunches!;
  }

  @override
  Future<GetLaunch$Query$Launch?> getLaunchByMissionId(String missionId) async {
    if (_launches.containsKey(missionId)) {
      return _launches[missionId]!;
    }

    _launches[missionId] = (await _client.execute(
            GetLaunchQuery(variables: GetLaunchArguments(id: missionId))))
        .data
        ?.launch;
    return _launches[missionId]!;
  }

  @override
  Future<List<GetRockets$Query$Rocket?>> getRockets() async {
    if (_rockets != null) return _rockets!;
    _rockets = (await _client.execute(GetRocketsQuery())).data!.rockets!;
    return _rockets!;
  }
}
