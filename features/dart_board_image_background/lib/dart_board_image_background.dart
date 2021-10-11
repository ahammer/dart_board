import 'package:dart_board_core/dart_board_core.dart';
import 'package:flutter/material.dart';

/// Give this filename or widget, and it'll apply a background as a page decoration
/// It'll also expose a background route, if you want to access it
/// other ways.

class ImageBackgroundFeature extends DartBoardFeature {
  @override
  final String namespace;

  @override
  final String implementationName;

  final String decorationName;

  final String? filename;

  final Widget? widget;
  Widget get fileWidget => Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover, image: AssetImage(filename!))),
      );

  ImageBackgroundFeature(
      {required this.namespace,
      required this.implementationName,
      this.filename,
      this.widget,
      this.decorationName = 'image_background'});

  @override
  List<RouteDefinition> get routes => [
        NamedRouteDefinition(
            route: '/${namespace}_route',
            builder: (ctx, settings) => widget ?? fileWidget)
      ];
  @override
  List<DartBoardDecoration> get pageDecorations => [
        DartBoardDecoration(
          name: decorationName,
          decoration: (context, child) => Stack(
            children: [widget ?? fileWidget, child],
          ),
        ),
      ];
}
