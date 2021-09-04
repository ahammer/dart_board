import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'extensions.dart';

///
/// Loads an image from an asset
///
Future<ui.Image> loadImageFromAsset(String asset, {String ext = "png"}) async {
  /// Read the bytes of the Data into a list
  
  final img = (await rootBundle.load('assets/$asset.$ext'))
      .chain((bytes) => Uint8List.view(bytes.buffer));

  final  completer = Completer<ui.Image>();

  // Decode the Image in a Future Envelope
  ui.decodeImageFromList(img, completer.complete);

  // Return the future
  return completer.future;
}
