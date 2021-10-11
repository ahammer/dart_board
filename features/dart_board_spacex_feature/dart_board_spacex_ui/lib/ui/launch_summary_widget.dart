import 'package:cached_network_image/cached_network_image.dart';
import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_spacex_repository/generated/graphql_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Single Launch Widget
class SingleLaunch extends StatelessWidget {
  final SingleLaunchViewModel viewModel;

  SingleLaunch(this.viewModel);

  @override
  Widget build(BuildContext context) => Card(
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            if (viewModel.showImage) _Image(viewModel: viewModel),
            if (viewModel.showTitle) _Header(viewModel: viewModel),
            _Footer(viewModel: viewModel),
            if (viewModel.clickable) _ClickableOverlay(viewModel: viewModel)
          ],
        ),
      );

  /// Static helper function to build from a view model
  static SingleLaunch builder(
          BuildContext context, SingleLaunchViewModel viewModel) =>
      SingleLaunch(viewModel);
}

/// This is the Inkwell and Material that sits on top of the card
/// for hover/click effects
class _ClickableOverlay extends StatelessWidget {
  const _ClickableOverlay({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final SingleLaunchViewModel viewModel;

  @override
  Widget build(BuildContext context) => Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => DartBoardCore.nav.appendPath("/${viewModel.missionName}"),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
        ),
      ));
}

class _Footer extends StatelessWidget {
  const _Footer({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final SingleLaunchViewModel viewModel;

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.bottomCenter,
        child: Hero(
          tag: viewModel.missionName + "_footer",
          child: Material(
            elevation: 2,
            color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  viewModel.launchDate,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Text(
                  viewModel.rocketName,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
        ),
      );
}

class _Image extends StatelessWidget {
  const _Image({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final SingleLaunchViewModel viewModel;

  @override
  Widget build(BuildContext context) => BooleanBuilder(
        value: viewModel.photos.isNotEmpty,
        onTrue: (ctx) => Hero(
          tag: viewModel.photos.first,
          child: CachedNetworkImage(
            width: double.infinity,
            height: double.infinity,
            imageUrl: viewModel.photos.first,
            fit: BoxFit.cover,
          ),
        ),
        onFalse: (ctx) => Material(
          color: Colors.black,
          child: Center(child: Text('No Image')),
        ),
      );
}

class _Header extends StatelessWidget {
  const _Header({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final SingleLaunchViewModel viewModel;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
        child: Align(
          alignment: Alignment.center,
          child: Hero(
            tag: viewModel.missionName,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
              child: Text(
                viewModel.missionName,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    ?.copyWith(fontWeight: FontWeight.bold, shadows: [
                  Shadow(blurRadius: 2, offset: const Offset(2, 2)),
                ]),
              ),
            ),
          ),
        ),
      );
}

/// View Model for the summary view
class SingleLaunchViewModel {
  final bool clickable;
  final bool showTitle;
  final bool showImage;

  final String id;
  final String missionName;
  final String rocketName;
  final String launchDate;

  static final DateFormat _dateFormat = DateFormat.yMd().add_jm();

  final List<String> photos;

  SingleLaunchViewModel({
    required this.id,
    required this.missionName,
    required this.rocketName,
    required this.photos,
    required this.launchDate,
    required this.clickable,
    required this.showTitle,
    required this.showImage,
  });

  /// Static helper to build a ViewModel from a graphql response
  static SingleLaunchViewModel fromPastLaunch(
          GetPastLaunches$Query$Launch gqlLaunch,
          {bool clickable = true,
          bool showTitle = true,
          bool showImage = false}) =>
      SingleLaunchViewModel(
          id: gqlLaunch.id ?? "-1",
          rocketName: gqlLaunch.rocket?.rocketName ?? "",
          launchDate: _dateFormat.format(gqlLaunch.launchDateLocal!),
          missionName: gqlLaunch.missionName ?? "Unknown",
          clickable: clickable,
          showTitle: showTitle,
          showImage: showImage,
          photos: gqlLaunch.links?.flickrImages?.whereType<String>().toList() ??
              <String>[]);
}
