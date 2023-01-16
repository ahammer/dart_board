import 'package:cached_network_image/cached_network_image.dart';
import 'package:dart_board_widgets/dart_board_widgets.dart';
import 'package:dart_board_locator/dart_board_locator.dart';
import 'package:dart_board_spacex_repository/impl/spacex_repository.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'launch_summary_widget.dart';

class LaunchDataUriShim extends StatelessWidget {
  final Uri uri;

  const LaunchDataUriShim({
    required this.uri,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      LaunchDataScreen(missionName: uri.pathSegments.last);
}

class LaunchDataScreen extends StatefulWidget {
  final String missionName;

  const LaunchDataScreen({Key? key, required this.missionName})
      : super(key: key);

  @override
  State<LaunchDataScreen> createState() => _LaunchDataScreenState();
}

class _LaunchDataScreenState extends State<LaunchDataScreen> {
  late final pageBody = WidgetStream((ctx) async* {
    final repo = locate<SpaceXRepository>();

    final summary =
        await repo.getLaunchSummaryByMissionName(widget.missionName);
    final detailsFuture = repo.getLaunchByMissionName(widget.missionName);

    /// Lets Show the Header (We Have the Summary)
    final headerWidget = _HeaderWidget(summary: summary);
    final List<Widget> imageWidgets =
        (summary?.links?.flickrImages ?? <String>[])
            .map((e) => Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: e!.replaceAll('_o.', '_q.'),
                      fit: BoxFit.cover,
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          launch(e);
                        },
                      ),
                    ),
                  ],
                ))
            .toList();

    /// Show the Initial Layout (With a Linear Progress Indicator and header)
    yield DetailsSliverList(
      title: widget.missionName,
      header: headerWidget,
      images: imageWidgets,
    );
    //yield Column(
    //  children: [headerWidget, LinearProgressIndicator()],
    //);

    final detailsViewModel =
        LaunchDetailsViewModel.from((await detailsFuture)!);
    final detailsWidget = _LaunchDetailText(details: detailsViewModel);
    final linksWidget = _LaunchLinks(detailsViewModel: detailsViewModel);
    final badgeWidget = detailsViewModel.missionDecal.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: AspectRatio(
                aspectRatio: 1.0,
                child: CachedNetworkImage(
                    imageUrl: detailsViewModel.missionDecal)),
          )
        : Container();

    yield DetailsSliverList(
      title: widget.missionName,
      details: detailsWidget,
      header: Stack(
        fit: StackFit.expand,
        children: [headerWidget, badgeWidget],
      ),
      links: linksWidget,
      images: imageWidgets,
    );
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        body: pageBody,
      );
}

class _LaunchLinks extends StatelessWidget {
  const _LaunchLinks({
    Key? key,
    required this.detailsViewModel,
  }) : super(key: key);

  final LaunchDetailsViewModel detailsViewModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (detailsViewModel.articleLink.isNotEmpty)
              MaterialButton(
                onPressed: () => launch(detailsViewModel.articleLink),
                child: Text("Article"),
              ),
            if (detailsViewModel.youtubeLink.isNotEmpty)
              MaterialButton(
                onPressed: () => launch(detailsViewModel.youtubeLink),
                child: Text("Youtube"),
              ),
            if (detailsViewModel.redditCampaignLink.isNotEmpty)
              MaterialButton(
                onPressed: () => launch(detailsViewModel.redditCampaignLink),
                child: Text("Reddit"),
              ),
            if (detailsViewModel.pressKitLink.isNotEmpty)
              MaterialButton(
                onPressed: () => launch(detailsViewModel.pressKitLink),
                child: Text("Press Kit"),
              ),
          ],
        ),
      ),
    );
  }
}

class DetailsSliverList extends StatelessWidget {
  final String title;
  final Widget header;
  final Widget? links;
  final Widget? details;
  final List<Widget> images;

  const DetailsSliverList({
    Key? key,
    required this.header,
    this.details,
    this.links,
    required this.images,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(title),
            collapsedHeight: 150,
            expandedHeight: 400,
            flexibleSpace: header,
            pinned: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              links ?? LinearProgressIndicator(),
              if (details != null) details!
            ]),
          ),
          SliverGrid.extent(
            maxCrossAxisExtent: 150,
            children: images,
          )
        ],
      );
}

class _LaunchDetailText extends StatelessWidget {
  const _LaunchDetailText({
    Key? key,
    required this.details,
  }) : super(key: key);

  final LaunchDetailsViewModel details;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: 8),
          Text(details.details),
        ],
      ),
    ));
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({
    Key? key,
    required this.summary,
  }) : super(key: key);

  final GetPastLaunches$Query$Launch? summary;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Convertor<GetPastLaunches$Query$Launch, SingleLaunchViewModel>(
          convertor: (launchData) => SingleLaunchViewModel.fromPastLaunch(
              launchData,
              clickable: false,
              showImage: true,
              showTitle: false),
          builder: SingleLaunch.builder,
          input: summary!),
    );
  }
}

class LaunchDetailsViewModel {
  final String details;
  final String articleLink;
  final String youtubeLink;
  final String redditCampaignLink;
  final String pressKitLink;
  final String missionDecal;

  LaunchDetailsViewModel({
    required this.details,
    required this.articleLink,
    required this.youtubeLink,
    required this.pressKitLink,
    required this.redditCampaignLink,
    required this.missionDecal,
  });

  static LaunchDetailsViewModel from(GetLaunch$Query$Launch gqlDetails) =>
      LaunchDetailsViewModel(
          details: gqlDetails.details ?? "",
          articleLink: gqlDetails.links?.articleLink ?? "",
          youtubeLink: gqlDetails.links?.videoLink ?? "",
          redditCampaignLink: gqlDetails.links?.redditCampaign ?? "",
          pressKitLink: gqlDetails.links?.presskit ?? "",
          missionDecal: gqlDetails.links?.missionPatch ?? "");
}
