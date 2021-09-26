import 'package:dart_board_locator/dart_board_locator.dart';
import 'package:flutter/material.dart';
import 'package:spacex_launch_repository/spacex_data_layer_feature.dart';

import 'past_launch_list.dart';

class LaunchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Past Launches'),
        ),
        body: locateAndBuild<PastLaunches>((ctx, data) {
          if (data.hasError) {
            return Text(data.error.toString());
          }

          if (data.hasLoaded) {
            return Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                    width: 400, child: PastLaunchesList(data.launches)));
          }

          return Center(
              child: Card(
                  child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Loading"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            ],
          )));
        }),
      );
}
