import 'package:dart_board_core/dart_board_core.dart';
import 'package:dart_board_debug/debug_feature.dart';
import 'package:dart_board_template_bottomnav/dart_board_template_bottomnav.dart';
import 'package:flutter/material.dart';

import 'features/cart_feature_complete.dart';
import 'features/details_feature.dart';
import 'features/listing_feature.dart';
import 'features/mock_checkout_feature.dart';

/// If you want to learn Dart Board, you found the correct place.
/// This application serves as a starter template and doubles
/// as the tutorial working ground.
///
/// It's not meant to be complete project, but a working project to serve
/// as a starting point for learning/structure.

/// App Entry Point.
///
/// Features are defined here, along with config.
void main() {
  runApp(DartBoard(
    features: [
      DetailsFeature(),
      ListingFeature(),
      CartFeature(itemPreviewRoute: "/details_by_id"),
      DebugFeature(),
      BottomNavTemplateFeature(route: '/home', config: _templateConfig),
      MockCheckoutFeature()
    ],
    initialPath: '/home',
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
