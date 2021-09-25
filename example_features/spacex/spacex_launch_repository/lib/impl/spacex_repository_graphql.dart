import 'package:artemis/artemis.dart';

import 'spacex_repository.dart';
import '../generated/graphql_api.dart';

const _ENDPOINT = "https://api.spacex.land/graphql";

class SpaceXRepositoryGraphQL extends SpaceXRepository {
  final _client = ArtemisClient(_ENDPOINT);
  @override
  Future<List<LaunchData>> getPastLaunches() async =>
      (await _client.execute(GetPastLaunchesQuery()))
          .data!
          .launchesPast!
          .map((e) => LaunchData.fromGql(e))
          .toList();
}
