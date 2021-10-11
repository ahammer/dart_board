import 'package:dart_board_core/dart_board_core.dart';
import 'package:dart_board_template_bottomnav/state/bottom_nav_state.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'details_feature.dart';
import 'repository_feature.dart';

class ListingFeature extends DartBoardFeature {
  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: "/listings", builder: (context, settings) => _listingsScreen)
      ];

  @override
  String get namespace => "ListingsFeature";

  @override
  List<DartBoardFeature> get dependencies =>
      [RepositoryFeature(repository: MockRepository())];
}

final _listingsScreen = ListingScreen();

class ListingScreen extends StatefulWidget {
  @override
  _ListingScreenState createState() => _ListingScreenState();
}

class _ListingScreenState extends State<ListingScreen> {
  late final results = RepositoryMessenger.performSearch(context);
  int _selection = 0;

  @override
  Widget build(BuildContext context) => Container(
      child: FutureBuilder<List<ShortRecord>>(
          future: results,
          builder: (ctx, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              /// Safe to unwrap
              final data = snapshot.data!;
              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (ctx, idx) => ListTile(
                      selected: _selection == idx,
                      title: Row(
                        children: [
                          Expanded(
                              child: Text(
                            data[idx].title,
                            style: Theme.of(context).textTheme.headline3,
                          )),
                          Stack(
                            children: [
                              Container(
                                width: 200,
                                height: 200,
                                child: Material(
                                  elevation: 2,
                                  child: FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: data[idx].imageUrl,
                                    fit: BoxFit.cover,
                                    width: 200,
                                  ),
                                ),
                              ),
                              Card(
                                  child: InkWell(
                                      onTap: () {
                                        context
                                            .dispatchMethod("addItemToCart", {
                                          "id": data[idx].id,
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Add"),
                                      )))
                            ],
                          ),
                        ],
                      ),
                      onTap: () {
                        /// Since we use BottomNav we can use the BottomNavMessenger
                        /// to tell BottomNav what tab to show
                        BottomNavMessenger.requestNewRoute(context, "/details");

                        /// Since we have a global state for a Main Details screen
                        /// we can call that here too.
                        MainDetailsMessenger.setId(context, idx);
                        setState(() {
                          /// Notify the selection
                          _selection = idx;
                        });
                      }));
            } else {
              return Text("Loading...");
            }
          }));
}
