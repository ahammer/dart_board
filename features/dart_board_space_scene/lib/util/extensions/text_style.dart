import 'package:flutter/material.dart';

/// Extension to TextStyle
extension TextStyleHelpers on TextStyle {
  /// User the Nova Mono font with this TextStyle
  TextStyle withNovaMono() =>
      copyWith(fontFamily: "NovaMono", fontWeight: FontWeight.bold);
}
