import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// What we show when a route is not found
class RouteNotFound extends StatelessWidget {
  const RouteNotFound();

  @override
  Widget build(BuildContext context) => Center(
          child: Card(
              child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text('404 Not Found\n${ModalRoute.of(context)!.settings.name}'),
      )));
}
