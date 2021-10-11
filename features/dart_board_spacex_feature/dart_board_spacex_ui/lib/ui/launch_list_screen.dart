import 'package:dart_board_widgets/dart_board_widgets.dart';
import 'package:dart_board_locator/dart_board_locator.dart';
import 'package:dart_board_spacex_repository/generated/graphql_api.dart';
import 'package:dart_board_spacex_repository/impl/spacex_repository.dart';
import 'package:dart_board_spacex_ui/ui/launch_summary_widget.dart';
import 'package:flutter/material.dart';

///
class LaunchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Launches'),
        ),
        body: WidgetStream(
          (BuildContext context) async* {
            yield CircularProgressIndicator();
            yield LaunchList(
                await locate<SpaceXRepository>().getPastLaunches());
          },
        ),
      );
}

class LaunchList extends StatelessWidget {
  final List<GetPastLaunches$Query$Launch?>? launches;

  const LaunchList(this.launches, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          childAspectRatio: 8.0, maxCrossAxisExtent: 1000),
      itemBuilder: (ctx, idx) => Convertor(
          convertor: SingleLaunchViewModel.fromPastLaunch,
          builder: SingleLaunch.builder,
          input: launches![idx]!),
      itemCount: launches!.length);
}
