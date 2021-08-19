import 'package:blank/features/details_feature.dart';
import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_template_bottomnav/state/bottom_nav_state.dart';
import 'package:flutter/material.dart';

import 'repository_feature.dart';

class ListingFeature extends DartBoardFeature {
  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: "/listings", builder: (settings, context) => _listingsScreen)
      ];

  @override
  String get namespace => "ListingsFeature";
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
                      title: Text(data[idx].title),
                      onTap: () {
                        /// Since we use BottomNav we can use the BottomNavMessenger
                        /// to tell BottomNav what tab to show
                        BottomNavMessenger.requestNewRoute(context, "/details");
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
