import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_locator/dart_board_locator.dart';
import 'package:flutter/material.dart';
import 'package:spacex_launch_repository/spacex_data_layer_feature.dart';
import 'package:transparent_image/transparent_image.dart';

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
            final images = data.launches.fold<List<String>>(
                <String>[], (a, b) => [...a, ...b.flickrImages]);
            return Row(
              children: [
                SizedBox(width: 400, child: PastLaunchesList(data.launches)),
                Expanded(
                    child: CustomScrollView(
                  slivers: [
                    SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200.0,
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 4.0,
                        childAspectRatio: 1.0,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32)),
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: () {
                                  final launchName = data.launches
                                      .where((e) => e.flickrImages
                                          .contains(images[index]))
                                      .first
                                      .missionName;
                                  DartBoardCore.nav.appendRoute('/$launchName');
                                },
                                child: FadeInImage.memoryNetwork(
                                    fit: BoxFit.cover,
                                    placeholder: kTransparentImage,
                                    image:
                                        images[index].replaceAll('_o', '_m')),
                              ));
                        },
                        childCount: images.length,
                      ),
                    )
                  ],
                ))
              ],
            );
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
