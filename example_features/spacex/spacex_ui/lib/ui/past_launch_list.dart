import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_space_scene/space_scene_feature.dart';
import 'package:dart_board_theme/dart_board_theme.dart';
import 'package:flutter/material.dart';
import 'package:spacex_launch_repository/impl/spacex_repository.dart';
import 'package:spacex_launch_repository/impl/spacex_repository_graphql.dart';
import 'package:spacex_launch_repository/spacex_data_layer_feature.dart';
import 'package:dart_board_locator/dart_board_locator.dart';
import 'package:intl/intl.dart';

import 'launch_screen.dart';

final format = DateFormat.yMd().add_jm();

/// Shows a list-item for a launch
class LaunchListItem extends StatelessWidget {
  final LaunchData launch;

  const LaunchListItem(
    this.launch, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ListTile(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              launch.missionName,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            if (launch.launchDateLocal != null)
              Text(
                format.format(launch.launchDateLocal),
                style: Theme.of(context).textTheme.subtitle2,
              ),
          ],
        ),
        onTap: () => locate<LaunchScreenState>().selection = launch,
      );
}

class PastLaunchesList extends StatelessWidget {
  final List<LaunchData> launches;

  const PastLaunchesList(
    this.launches, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            "Past Launches",
            style: Theme.of(context)
                .textTheme
                .headline3!
                .copyWith(fontWeight: FontWeight.bold, shadows: [
              /// Embossed text
              Shadow(
                  blurRadius: 2, offset: Offset(0.5, 0.5), color: Colors.white),
              Shadow(
                  blurRadius: 2,
                  offset: Offset(-0.5, -0.5),
                  color: Colors.black),
            ]),
          ),
          Expanded(
            child: Card(
              color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
              child: ListView.builder(
                itemBuilder: (ctx, idx) => LaunchListItem(launches[idx]),
                itemCount: launches.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
