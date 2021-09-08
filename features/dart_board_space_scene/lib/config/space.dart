import 'dart:math';
import 'package:flutter/material.dart';

///
/// Configuration of the Space Clock
///

/// Light Theme Space Config
SpaceConfig get lightSpaceConfig => _LightSpaceConfig();

/// Dark Theme Space Config
SpaceConfig get darkSpaceConfig => _DarkSpaceConfig();

/// For Development: Locks to a theme
SpaceConfig? get overrideTheme => null;

/// Default Values for the Space Config
/// Also used for "Light"
abstract class SpaceConfig {
  /// sunSize = Size of the Sun as a multiplier of the screen size
  double get sunSize => 2;

  /// sunBaseSize = The "disc" that serves as the "surface" for the sun.
  /// Small values give more "corona"
  double get sunBaseSize => 0.95;

  /// sunOrbitMultiplierX - 0 = Center of Screen, 1 = Left/Right align with center of sun
  double get sunOrbitMultiplierX => 0.9;

  /// sunOrbitMultiplierY - 0 = Center of Screen, 1 = Top/Bottom algin with center of sun
  double get sunOrbitMultiplierY => 1.4;

  /// sunSpeed = Animation multiplier for the sun. Higher values speed the sun
  double get sunSpeed => 40;

  /// sunLayers = Images that are drawn at the sun's location at various rotations/blend modes
  List<SunLayer> get sunLayers => [
        SunLayer(
            image: "sun_1",
            mode: BlendMode.multiply,
            flipped: false,
            speed: -1),
        SunLayer(
            image: "sun_2", mode: BlendMode.plus, flipped: false, speed: 5),
        SunLayer(
            image: "sun_3", mode: BlendMode.plus, flipped: false, speed: -4),
        SunLayer(
            image: "sun_3", mode: BlendMode.multiply, flipped: true, speed: -3),
        SunLayer(
            image: "sun_4", mode: BlendMode.multiply, flipped: true, speed: 1),
      ];

  /// sunGradient = The sunBase is painted with this gradient.
  /// It's set to give a soft warm glow around the edges
  RadialGradient get sunGradient => RadialGradient(
      center: Alignment.center,
      radius: 0.5,
      colors: [Colors.white, Colors.deepOrange.withOpacity(0)],
      stops: const [0.985, 1]);

  /// earthSize = Size of the earth as a multiplier of screen size
  double get earthSize => 0.30;

  /// earthRotationSpeed = Speed the earth rotates on the screen cosmetic only
  double get earthRotationSpeed => -10;

  /// earthOrbitMultiplierX = Same as Sun
  double get earthOrbitMultiplierX => 0.15; //ScreenWidth / X

  /// earthOrbitMultiplierY = Same as Sun
  double get earthOrbitMultiplierY => 0.15; //ScreenWidth / X

  /// moonSize = Size of the moon as a multiplier of screen size
  double get moonSize => 0.14;

  /// moonOrbitMultiplierX = Same as Sun/Earth
  double get moonOrbitMultiplierX => 0.25; //ScreenWidth / X

  /// moonOrbitMultiplierY = Same as Sun/Earth but moon pivots around earth
  double get moonOrbitMultiplierY => 0.22; //ScreenWidth / X

  /// moonRotationSpeed = Speed the earth rotates on the screen cosmetic only
  double get moonRotationSpeed => -10;

  /// moonSizeVariation = moonSize +- moonSizeVariation
  /// as moon travels "front" to "back"
  double get moonSizeVariation => 0.03;

  /// backgroundRotationSpeedMultiplier = How fast the background and stars spin
  double get backgroundRotationSpeedMultiplier => 15;

  /// angleOffset = 0 degrees != 12:00, this constant offsets the
  /// clock to correct
  double get angleOffset => pi / 2;
}

/// Light Space Config, Defaults Only
class _LightSpaceConfig extends SpaceConfig {}

/// DarkSpaceConfig, Orbits/Scales changed slightly
class _DarkSpaceConfig extends SpaceConfig {
  @override
  double get sunSize => 0.3;
  @override
  double get earthSize => 0.280;
  @override
  double get moonSize => 0.08;
  @override
  double get sunOrbitMultiplierX => 0.25;
  @override
  double get sunOrbitMultiplierY => 0.2;
  @override
  double get earthOrbitMultiplierX => 0.25;
  @override
  double get earthOrbitMultiplierY => 0.2;
  @override
  double get moonOrbitMultiplierX => 0.20; //ScreenWidth / X
  @override
  double get moonOrbitMultiplierY => 0.22; //ScreenWidth / X
  @override
  double get moonRotationSpeed => -10;
  @override
  double get moonSizeVariation => 0.01;
}

/// Represents a "layer" of the sun
///
/// This is baked into the config so we can say
/// what layers are drawn, with what blend mode,
/// and if they are visually flipped
class SunLayer {
  /// Construct a sun layer
  SunLayer(
      {required this.image,
      required this.mode,
      required this.flipped,
      required this.speed});

  /// The image name, e.g. sun_1 or sun_2, that would be in the map
  final String image;

  /// The blend mode we will draw this layer
  final BlendMode mode;

  /// We can flip layers to give fake randomness
  final bool flipped;

  /// And we should set a speed the layers transition
  final double speed;
}
