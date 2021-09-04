import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

///📏📏📏📏📏📏📏📏📏📏
/// Helpers for the Vector3 class
extension VectorHelpers on vector.Vector3 {
  /// Collapse a vector to a offset
  Offset toOffset() => Offset(x, y);
}
