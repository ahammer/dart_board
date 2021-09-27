import 'package:flutter/material.dart';
import 'package:spacex_launch_repository/impl/spacex_repository.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';

/// The details pane
class DetailsPanel extends StatelessWidget {
  final LaunchData data;
  const DetailsPanel(
    this.data, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
      color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
      child: Container(
          height: double.infinity,
          child: Column(
            children: [
              /// Launch Details
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "${data.missionName} / ${data.siteName} / ${data.rocketName}",
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),

              /// Action Buttons
              Row(
                children: [
                  if (data.articleLink.isNotEmpty)
                    MaterialButton(
                      onPressed: () {
                        launch(data.articleLink);
                      },
                      child: Text("Article"),
                    ),
                  if (data.videoLink.isNotEmpty)
                    MaterialButton(
                      onPressed: () {
                        launch(data.videoLink);
                      },
                      child: Text("Video"),
                    ),
                ],
              ),

              /// Images not visible
              if (data.flickrImages.isEmpty)
                Expanded(
                  flex: 1,
                  child: Card(
                    child: Center(child: Text("No Images")),
                  ),
                ),

              /// Images are visible
              if (data.flickrImages.isNotEmpty)
                Expanded(
                  flex: 1,
                  child: Container(
                      child: PageView(
                    scrollDirection: Axis.horizontal,
                    children: data.flickrImages
                        .map((e) => FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: e,
                            ))
                        .toList(),
                  )),
                ),
            ],
          )));
}
