import 'package:dart_board_core/dart_board.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

import 'repository_feature.dart';

class DetailsFeature extends DartBoardFeature {
  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: "/details",
            builder: (settings, context) => MainDetailsScreen()),
        NamedRouteDefinition(
            route: "/details_by_id",
            builder: (settings, context) {
              dynamic args = settings.arguments;

              return DetailsScreen(id: args["id"]);
            })
      ];

  @override
  List<DartBoardDecoration> get appDecorations => [
        DartBoardDecoration(
            decoration: (BuildContext context, Widget child) =>
                ChangeNotifierProvider.value(
                    value: MainDetailsState(), child: child),
            name: 'MainDetailsState'),
      ];

  @override
  String get namespace => "DetailsFeature";

  @override
  List<DartBoardFeature> get dependencies =>
      [RepositoryFeature(repository: MockRepository())];
}

// State for the "Main" route inside the tabs
class MainDetailsState extends ChangeNotifier {
  int _id = 0;

  set id(int id) {
    _id = id;
    notifyListeners();
  }

  int get id => _id;
}

// Messenger class to send messages to the State class
class MainDetailsMessenger {
  static void setId(BuildContext context, int id) =>
      Provider.of<MainDetailsState>(context, listen: false).id = id;
}

class MainDetailsScreen extends StatefulWidget {
  @override
  _MainDetailsScreenState createState() => _MainDetailsScreenState();
}

class _MainDetailsScreenState extends State<MainDetailsScreen> {
  @override
  Widget build(BuildContext context) => Consumer<MainDetailsState>(
      builder: (ctx, state, child) => DetailsScreen(id: state.id));
}

/// Details for a particular ID
class DetailsScreen extends StatefulWidget {
  final int id;

  const DetailsScreen({Key? key, required this.id}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late Future<LongRecord> details;

  // Re-initialize the future
  void initFuture() {
    details = RepositoryMessenger.fetchDetails(context, widget.id);
  }

  @override
  void initState() {
    initFuture();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant DetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      initFuture();
    });
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<LongRecord>(
      future: details,
      builder: (ctx, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final data = snapshot.data!;
          var textTheme = Theme.of(context).textTheme;
          return Stack(
            children: [
              FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: data.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 300,
                  child: Card(
                      child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            data.title,
                            style: textTheme.headline3,
                          ),
                          Text(
                            data.price,
                            style: textTheme.headline4,
                          ),
                          Container(
                            height: 48,
                          ),
                          Text(
                            data.description,
                            style: textTheme.bodyText1,
                          ),
                        ],
                      ),
                    ),
                  )),
                ),
              ),
            ],
          );
        } else {
          return LinearProgressIndicator();
        }
      });
}
