import 'dart:math';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import '../../config/space.dart';

/// View Model for the Space Clock
class SpaceViewModel {
  /// Construct a Space Clock View Model
  SpaceViewModel({
    required this.moonRotation,
    required this.moonSize,
    required this.sunRotation,
    required this.sunSize,
    required this.sunOffset,
    required this.sunBaseRadius,
    required this.earthOffset,
    required this.earthSize,
    required this.moonOffset,
    required this.backgroundRotation,
    required this.centerOffset,
    required this.backgroundSize,
    required this.earthRotation,
  });

  /// Create a VM out of a time/config/screen size
  factory SpaceViewModel.of(DateTime time, SpaceConfig config, Size size) {
    /// Center of the Screen
    final centerOffset = Offset(size.width / 2, size.height / 2);

    /// Background size (at least hyp to fill screen as rotating)
    final backgroundSize =
        sqrt(size.width * size.width + size.height * size.height);

    /// The moon orbit (0-360 every 60 sec)
    final moonOrbit = (time.second * 1000 + time.millisecond) / 60000 * 2 * pi;

    /// The earth orbit (0-360 every 60 minutes)
    final earthOrbit =
        (time.minute * 60 * 1000 + time.second * 1000 + time.millisecond) /
            3600000 *
            2 *
            pi;

    /// The suns rotation (0-360 every 12 hours)
    final sunOrbit = (time.hour / 12.0) * 2 * pi + (1 / 12.0 * earthOrbit);

    /// The "Rotation" of the sun
    /// Is the base speed of the rotational perlin noise for the sun
    final sunRotation = sunOrbit * config.sunSpeed;

    /// The sun's diameter
    final sunSize = size.width * config.sunSize;

    /// The sun's base disc radius
    final sunBaseRadius = sunSize / 2 * config.sunBaseSize;

    /// The X and Y Offsets for the sun
    final sunOffsetX = cos(sunOrbit - config.angleOffset) *
        size.width *
        config.sunOrbitMultiplierX;
    final sunOffsetY = sin(sunOrbit - config.angleOffset) *
        size.height *
        config.sunOrbitMultiplierY;

    /// The X and Y offsets of the earth
    final earthOffsetX = cos(earthOrbit - config.angleOffset) *
        size.width *
        config.earthOrbitMultiplierX;
    final earthOffsetY = sin(earthOrbit - config.angleOffset) *
        size.height *
        config.earthOrbitMultiplierY;

    /// We use this in the Y offset of the Moon and the Scale
    final moonSin = sin(moonOrbit - config.angleOffset);

    //Moon orbits 1/4 a screen distance away from the earth as well
    final moonOffsetX = cos(moonOrbit - config.angleOffset) *
        size.width *
        config.moonOrbitMultiplierX;
    final moonOffsetY = moonSin * size.height * config.moonOrbitMultiplierY;

    /// The scale of the moon, adjusts with SIN of the rotation
    /// (bigger at bottom, smaller at top)
    final moonScale = moonSin * config.moonSizeVariation;
    final moonSize = size.width * (config.moonSize + moonScale);

    /// The rotating of the background image
    final backgroundRotation =
        earthOrbit * config.backgroundRotationSpeedMultiplier;

    /// The rotation of the moon
    final moonRotation = earthOrbit * config.moonRotationSpeed;

    /// The size of the earth
    final earthSize = size.width * config.earthSize;

    /// The Screen Offsets of the Sun, Earth and Moon
    /// Screen offset of the moon
    final moonOffset = Offset(size.width / 2 + earthOffsetX + moonOffsetX,
        size.height / 2 + earthOffsetY + moonOffsetY);

    final earthOffset =
        Offset(size.width / 2 + earthOffsetX, size.height / 2 + earthOffsetY);

    final sunOffset =
        Offset(size.width / 2 + sunOffsetX, size.height / 2 + sunOffsetY);

    /// Create the view model we draw with
    return SpaceViewModel(
        backgroundRotation: backgroundRotation,
        earthOffset: earthOffset,
        earthSize: earthSize,
        earthRotation: earthOrbit * config.earthRotationSpeed,
        moonSize: moonSize,
        sunBaseRadius: sunBaseRadius,
        sunSize: sunSize,
        sunRotation: sunRotation,
        sunOffset: sunOffset,
        moonOffset: moonOffset,
        moonRotation: moonRotation,
        centerOffset: centerOffset,
        backgroundSize: backgroundSize);
  }

  /// Rotation of the Moon
  final double moonRotation;

  /// Size of the Moon
  final double moonSize;

  /// Rotation of the Sun
  final double sunRotation;

  /// Size of the sun
  final double sunSize;

  /// Sun's screen offset
  final Offset sunOffset;

  /// Radius of the suns's base disc
  final double sunBaseRadius;

  /// Size of the background
  final double backgroundSize;

  /// Center of the screen
  final Offset centerOffset;

  /// Size of the earth
  final double earthSize;

  /// Screen offset of the earth
  final Offset earthOffset;

  /// Rotation of the background
  final double backgroundRotation;

  /// Moons offset in screen coords
  final Offset moonOffset;

  /// Earth rotation
  final double earthRotation;
}
