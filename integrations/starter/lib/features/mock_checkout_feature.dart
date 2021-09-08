import 'package:dart_board_core/dart_board.dart';
import 'package:flutter/material.dart';

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
          /// The "cart" is still visible, this will dismiss it
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Checkout Flow Triggered')));
        }
      };
}
