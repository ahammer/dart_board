import 'package:artemis/artemis.dart';

import 'spacex_repository.dart';
import '../generated/graphql_api.dart';

const _ENDPOINT = "https://api.spacex.land/graphql";

class SpaceXRepositoryGraphQL extends SpaceXRepository {
  final _client = ArtemisClient(_ENDPOINT);

  List<LaunchData>? _cache;

  @override
  Future<List<LaunchData>> getPastLaunches() async {
    if (_cache != null) return _cache!;

    _cache = (await _client.execute(GetPastLaunchesQuery()))
        .data!
        .launchesPast!
        .map((e) => LaunchData.fromGql(e))
        .toList();

    return _cache!;
  }
}
