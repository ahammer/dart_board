import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_locator/dart_board_locator.dart';
import 'package:flutter/material.dart';
import 'package:spacex_launch_repository/impl/spacex_repository.dart';

class SpaceXDataLayerFeature extends DartBoardFeature {
  final SpaceXRepository repository;

  /// Give it a repository to actually fetch the data
  SpaceXDataLayerFeature(this.repository);

  @override
  String get namespace => "SpaceXRepositoryFeature";

  @override
  List<DartBoardDecoration> get appDecorations => [
        LocatorDecoration<PastLaunches>(() => PastLaunches()),
        DartBoardDecoration(
          name: "LaunchDataFetcher",
          decoration: (ctx, child) => LifeCycleWidget(
            key: ValueKey("LaunchDataFetcher"),
            init: (ctx) async => locate<PastLaunches>().launches =
                await repository.getPastLaunches(),
            child: child,
          ),
        )
      ];

  @override
  List<DartBoardFeature> get dependencies => [DartBoardLocatorFeature()];
}

/// A container for the Past Launches, will update as data updates
class PastLaunches extends ChangeNotifier {
  Exception? _error;
  bool _hasLoaded = false;

  List<LaunchData> _data = [];

  /// Getters
  List<LaunchData> get launches => _data;
  Exception? get error => _error;
  bool get hasError => _error != null;
  bool get hasLoaded => _hasLoaded;

  set exception(Exception e) {
    _error = e;
    notifyListeners();
  }

  set launches(List<LaunchData> data) {
    _hasLoaded = true;
    _data = data;
    notifyListeners();
  }
}
