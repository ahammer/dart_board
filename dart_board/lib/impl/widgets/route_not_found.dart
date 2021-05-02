import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// What we show when a route is not found
class RouteNotFound extends StatelessWidget {
  const RouteNotFound();

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text("Route not found")));
}
