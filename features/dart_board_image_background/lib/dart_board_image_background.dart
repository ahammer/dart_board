import 'package:dart_board_core/dart_board.dart';
import 'package:flutter/material.dart';

class ImageBackgroundFeature extends DartBoardFeature {
  @override
  final String namespace;

  @override
  final String implementationName;

  final String decorationName;

  final String filename;

  ImageBackgroundFeature(
      {required this.filename,
      required this.namespace,
      required this.implementationName,
      this.decorationName = 'image_background'});

  @override
  List<DartBoardDecoration> get pageDecorations => [
        DartBoardDecoration(
          name: decorationName,
          decoration: (context, child) => Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover, image: AssetImage(filename))),
              ),
              child
            ],
          ),
        ),
      ];
}
