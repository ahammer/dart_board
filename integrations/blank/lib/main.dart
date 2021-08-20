import 'package:blank/features/repository_feature.dart';
import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_debug/debug_feature.dart';
import 'package:dart_board_template_bottomnav/dart_board_template_bottomnav.dart';
import 'package:flutter/material.dart';

import 'features/details_feature.dart';
import 'features/listing_feature.dart';

/// App Entry Point.
///
/// Features are defined here, along with config.
void main() {
  runApp(DartBoard(
    features: [
      /// We load our repository with mock data
      RepositoryFeature(repository: MockRepository()),
      DetailsFeature(),
      ListingFeature(),
      DebugFeature(),
      BottomNavTemplateFeature(route: '/home', config: _templateConfig)
    ],
    initialRoute: '/home',
  ));
}

/// Template Config for the BottomNav template
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
