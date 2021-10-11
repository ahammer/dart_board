import 'package:artemis/artemis.dart';

import 'spacex_repository.dart';
import '../generated/graphql_api.dart';

const _ENDPOINT = "https://api.spacex.land/graphql";

class SpaceXRepositoryGraphQL extends SpaceXRepository {
  final _client = ArtemisClient(_ENDPOINT);

  List<GetPastLaunches$Query$Launch?>? _pastLaunches;

  @override
  Future<List<GetPastLaunches$Query$Launch?>> getPastLaunches() async {
    if (_pastLaunches != null) return _pastLaunches!;
    _pastLaunches =
        (await _client.execute(GetPastLaunchesQuery())).data!.launchesPast;
    return _pastLaunches!;
  }

  @override
  Future<GetLaunch$Query$Launch?> getLaunchByMissionId(
          String missionId) async =>
      (await _client.execute(
              GetLaunchQuery(variables: GetLaunchArguments(id: missionId))))
          .data
          ?.launch;

  @override
  Future<List<GetRockets$Query$Rocket?>> getRockets() async =>
      (await _client.execute(GetRocketsQuery())).data!.rockets!;
}
