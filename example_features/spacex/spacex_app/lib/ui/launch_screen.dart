import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_locator/dart_board_locator.dart';
import 'package:flutter/material.dart';
import 'package:spacex_launch_repository/impl/spacex_repository.dart';
import 'package:spacex_launch_repository/spacex_data_layer_feature.dart';

import 'launch_details.dart';
import 'past_launch_list.dart';

class LaunchScreenState extends ChangeNotifier {
  LaunchData? _selection;

  LaunchData? get selection => _selection;

  set selection(LaunchData? data) {
    _selection = data;
    notifyListeners();
  }
}

class LaunchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Stack(children: [
        RouteWidget('/clock'),
        locateAndBuild<PastLaunches>((ctx, data) {
          if (data.hasError) {
            return Text(data.error.toString());
          }

          if (data.hasLoaded) {
            final children = [
              Expanded(
                child: PastLaunchesList(data.launches),
              ),
              Container(
                width: 16,
              ),
              locateAndBuild<LaunchScreenState>(
                  (ctx, state) => state._selection == null
                      ? Expanded(child: Container())
                      : Expanded(
                          child: AnimatedSwitcher(
                              duration: Duration(milliseconds: 200),
                              child: DetailsPanel(
                                state._selection!,
                                key: ValueKey(state._selection),
                              ))))
            ];

            return LayoutBuilder(builder: (ctx, constraints) {
              if (constraints.maxWidth > constraints.maxHeight)
                return Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Row(children: children),
                );
              else
                return Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(children: children),
                );
            });
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
        })
      ]);
}
