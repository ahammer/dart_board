/// Interface to get at the GraphQL data
abstract class SpaceXRepository {
  Future<List<GetPastLaunches$Query$Launch?>> getPastLaunches();
  Future<GetLaunch$Query$Launch?> getLaunchByMissionId(String missionId);
  Future<List<GetRockets$Query$Rocket?>> getRockets();

  Future<GetLaunch$Query$Launch?> getLaunchByMissionName(
          String missionName) async =>
      getLaunchByMissionId((await getPastLaunches())
          .where((element) => element?.missionName == missionName)
          .first!
          .id!);

  Future<GetPastLaunches$Query$Launch?> getLaunchSummaryByMissionName(
          String missionName) async =>
      (await getPastLaunches())
          .where((element) => element?.missionName == missionName)
          .first;
}

class GetRockets$Query$Rocket {}

class GetLaunch$Query$Launch {}

class GetPastLaunches$Query$Launch {
  var missionName;

  var id;
}
