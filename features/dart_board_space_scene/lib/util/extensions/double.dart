///🧮🧮🧮🧮🧮🧮🧮🧮🧮🧮
/// Math Helpers
///
extension DoubleHelpers on double {
  ///
  /// Gets the fraction of a double, e.g. (1.234) => 0.234
  ///
  double fraction() => this - floorToDouble();
}
