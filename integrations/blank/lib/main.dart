import 'package:blank/features/repository_feature.dart';
import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_template_bottomnav/dart_board_template_bottomnav.dart';
import 'package:flutter/material.dart';

import 'features/details_feature.dart';
import 'features/listing_feature.dart';

void main() {
  runApp(DartBoard(
    features: [
      /// We load our repository with mock data
      RepositoryFeature(repository: MockRepository()),
      DetailsFeature(),
      ListingFeature(),
      BottomNavTemplateFeature(route: '/home', config: _templateConfig)
    ],
    initialRoute: '/home',
  ));
}

const _templateConfig = [
  {
    'route': '/listings',
    'label': 'Search',
    'color': Colors.blue,
    'icon': Icons.search
  },
  {
    'route': '/details',
    'label': 'Details',
    'color': Colors.red,
    'icon': Icons.file_present
  }
];
