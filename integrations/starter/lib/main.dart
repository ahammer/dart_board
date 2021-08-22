import 'package:dart_board_core/dart_board.dart';
import 'package:dart_board_debug/debug_feature.dart';
import 'package:dart_board_template_bottomnav/dart_board_template_bottomnav.dart';
import 'package:flutter/material.dart';

import 'features/cart_feature_complete.dart';
import 'features/details_feature.dart';
import 'features/listing_feature.dart';

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
      /// We load our repository with mock data
      DetailsFeature(),
      ListingFeature(),
      CartFeature(itemPreviewRoute: "/details_by_id"),
      DebugFeature(),
      BottomNavTemplateFeature(route: '/home', config: _templateConfig),
      // For CartFeature to pass the buck too
      MockCheckoutFeature()
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

/// This is here to close the loop on cart. It's not implemented, but it's a
/// good starting point to tinker
///
/// From this point it is up to you
///
/// You can bring in the Cart/Repository as Hard features or design
/// an agnostic checkout feature with contracts to decouple the features, just
/// as cart feature is written.
class MockCheckoutFeature extends DartBoardFeature {
  @override
  String get namespace => "Checkout";

  @override
  List<DartBoardFeature> get dependencies => [];

  @override
  Map<String, MethodCallHandler> get methodHandlers => {
        "startCheckout": (context, call) async {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Checkout Flow Triggered')));
        }
      };
}
