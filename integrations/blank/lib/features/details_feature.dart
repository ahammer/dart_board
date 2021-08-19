import 'package:dart_board_core/dart_board.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'repository_feature.dart';

class DetailsFeature extends DartBoardFeature {
  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: "/details",
            builder: (settings, context) => MainDetailsScreen())
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
          return Text(data.title);
        } else {
          return LinearProgressIndicator();
        }
      });
}
