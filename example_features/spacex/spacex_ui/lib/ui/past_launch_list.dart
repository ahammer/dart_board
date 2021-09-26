import 'package:dart_board_core/dart_board.dart';
import 'package:flutter/material.dart';
import 'package:spacex_launch_repository/impl/spacex_repository.dart';
import 'package:intl/intl.dart';

final format = DateFormat.yMd().add_jm();

/// Shows a list-item for a launch
class LaunchListItem extends StatelessWidget {
  final LaunchData launch;

  const LaunchListItem(
    this.launch, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          subtitle: Text(
            format.format(launch.launchDateLocal),
          ),
          title: Text(
            launch.missionName,
          ),
          onTap: () {
            Nav.appendRoute('/${launch.missionName}');
          },
        ),
      );
}

class PastLaunchesList extends StatelessWidget {
  final List<LaunchData> launches;

  const PastLaunchesList(
    this.launches, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView.builder(
          itemBuilder: (ctx, idx) => LaunchListItem(launches[idx]),
          itemCount: launches.length,
        ),
      );
}
