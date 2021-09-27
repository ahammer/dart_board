import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// What we show when a route is not found
class RouteNotFound extends StatelessWidget {
  final String route;
  const RouteNotFound(this.route);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('404\n"$route" Not Found')),
      );
}
