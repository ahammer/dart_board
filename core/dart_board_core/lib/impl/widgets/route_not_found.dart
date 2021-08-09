import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// What we show when a route is not found
class RouteNotFound extends StatelessWidget {
  final String route;
  const RouteNotFound(this.route);

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        height: double.infinity,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('"$route" Not Found'),
          ),
        ),
      );
}
