import 'dart:ui' as ui;
import 'package:flutter/material.dart';

///🖼️🖼️🖼️🖼️🖼️🖼️🖼️🖼️🖼️🖼️
/// Image Helpers
/// Extending ui.Image to make it easier to draw to the screen
final Rect kTargetRect =
    Rect.fromCenter(center: Offset.zero, width: 1, height: 1);

/// Helpers to draw an image
extension ImageHelpers on ui.Image {
  /// Draws a Square Image rotated at offset around it's axis
  void drawRotatedSquare(
      {required Canvas canvas,
      required double size,
      required Offset offset,
      required double rotation,
      required Paint paint,
      bool flip = false}) {
    canvas
      ..save()
      ..translate(offset.dx, offset.dy);

    if (flip) {
      canvas.scale(-1, 1);
    }

    canvas
      ..rotate(flip ? -rotation : rotation)
      ..scale(size)
      ..drawImageRect(this, bounds(), kTargetRect, paint)
      ..restore();
  }

  /// Creates a Rect bounds for this Image
  Rect bounds() => Rect.fromLTRB(0, 0, width.toDouble(), height.toDouble());
}
