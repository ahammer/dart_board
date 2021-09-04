import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../config/space.dart';
import '../../config/time.dart';
import '../../model.dart';
import '../../ui/animated_painter.dart';
import '../../util/extensions.dart';
import '../../util/image_loader.dart';
import 'space_view_model.dart';
import 'stars.dart';

///
/// Sun Clock
///
/// Draws the Actual Sun/Moon/Earth/Stars Clock
///
/// A general explanation is as follows
///
/// Draws in order
/// - Fixed star background (rotating over time, for motion effect)
///
/// - Star Simulation
///   - Matrix math for projecting and transforming to "time space"
///     and screen space
///   - Batched by Z distance to set size/color and draw with drawPoints()
///     to reduce draw calls
///
/// - Sun
///   - "Hour Hand".
///   - First draws a circle (Base Layer) in white
///   - Drawn in layers (4 images)
///   - The layers have varying blend modes (Multiply/Plus/SoftLight)
///     - Multiply to emulate sunspots
///     - Plus/Softlight to emulate light/glowing
///   - Layers rotate slowly in varying directions
///   - Each layer is drawn twice, once flipped and rotated in
///     opposite direction
///   - The effective 8 layers do a Perlin compose a perlin noise that
///     looks a lot like the sun.
///
/// - Earth
///   - "Minute Hand"
///   - Rotates around the center of the screen once per hour.
///   - Shadow layer is drawn over the earth, opposite the sun
///
/// - Moon
///   - "Seconds Hand"
///   - Rotates around earth once a minute
///   - Shadow layer is drawn over the moon, opposite the sun
///
/// Notes: This is graphics/math heavy, custom code to create the scene
///
///

/// Space Clock Scene
///
/// Handles the drawing of the space clock
class SpaceClockScene extends StatelessWidget {
  /// SpaceClockScene
  ///
  /// Constructs the space_clock, give it a ClockModel
  const SpaceClockScene(this.model, {Key? key}) : super(key: key);

  /// ClockModel from the challenge
  final ClockModel model;

  @override
  Widget build(BuildContext context) => AnimatedPaint(
        painter: SpaceClockPainter(
            isDark: Theme.of(context).brightness == Brightness.dark),
      );
}

///
/// Pngs in the Asset folder used in this scene
///
/// Images are all either hand-made (like the sun)
/// or public domain (Earth/Moon/Space thanks courtesy of Nasa)
const List<String> images = [
  "earth",
  "moon",
  "sun_1",
  "sun_2",
  "sun_3",
  "sun_4",
  "stars",
  "shadow"
];

/// Only the Stars are a jpeg,
/// but I'll add this list as a hint
/// on whether to load a jpeg or a png
/// Generally on all images I want alpha
/// channel, but on background, size is
/// more important.
const List<String> jpegImages = ["stars"];

/// The images load into this map
final Map<String, ui.Image> _imageMap = {};

/// Have all the images loaded?
bool get _imagesLoaded => _imageMap.length == images.length;
bool _startedLoadingImages = false;

/// SpaceClockPainter
///
/// Implementation of the Canvas Drawing of the Space Clock
///
/// Psuedo:
///   Load Images
///   While Loading
///     Draw Loading Screen
///   When done Loading
///     Calculate Gears and Rotations
///     Draw Background
///     Draw Stars
///     Draw Sun
///     Draw Earth
///     Draw Moon
/// Note:
///  - This object acts as a singleton
///  - Theme Light/Dark is passed to the painter through the SpaceClockScene.build() method
class SpaceClockPainter extends AnimatedPainter {
  /// Constructor for the painter
  SpaceClockPainter({required this.isDark});

  /// Whether to draw dark config or not
  /// Note: This is mutating state
  final bool isDark;

  /// StandardPaint is just for the planets and background
  final Paint standardPaint = Paint()..filterQuality = FilterQuality.low;

  /// SunBasePaint will draw the gradient base/surface of the sun
  final Paint sunBasePaint = Paint()..filterQuality = FilterQuality.low;

  /// SunLayerPaint will adjust blendmode based on the layer as it
  final Paint sunLayerPaint = Paint()..filterQuality = FilterQuality.low;

  // Init on AnimatedPainter, we use this async method to load the images
  // we'll need
  @override
  void init() {
    if (!_imagesLoaded && !_startedLoadingImages) {
      _startedLoadingImages = true;
      for (var i = 0; i < images.length; i++) {
        final image = images[i];

        loadImageFromAsset(image,
                ext: jpegImages.contains(image) ? "jpg" : "png")
            .then((result) => _imageMap[image] = result);
      }
    }
  }

  // Paint the Loading Screen/Scene
  @override
  void paint(Canvas canvas, Size size) {
    //Keep it in the view
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Draw space or the loading screen
    _imagesLoaded ? drawSpace(canvas, size) : drawLoadingScreen(canvas, size);
  }

  /// drawLoadingScreen
  ///
  /// Psuedo
  ///   Build String "Loading ${PercentComplete}"
  ///   Draw String at the center of the screen
  ///
  void drawLoadingScreen(Canvas canvas, Size size) {
    // Fill the screen Black
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), standardPaint);

    // Set up the TextSpan (Specifies Text, Font, Etc)
    final percentLoaded =
        (_imageMap.length / images.length.toDouble() * 100).toInt();

    final span = TextSpan(
        style: TextStyle(color: Colors.white, fontSize: 24).withNovaMono(),
        text: "Loading ($percentLoaded%)....");

    // Set up the TextPainter, which decides how to draw the span
    final textPainter = TextPainter(
        text: span,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);

    // Layouter the Text (Measure it, etc)
    textPainter
      ..layout()
      ..paint(
          canvas,
          Offset(size.width / 2 - textPainter.width / 2,
              size.height / 2 - textPainter.height / 2));
  }

  /// drawSpace
  ///
  /// Draws everything in space
  /// Psuedo:
  ///  Calculate Orbital Rotations
  ///  Draw the Background
  ///  Draw the Stars
  ///  Draw the Sun
  ///  Draw the Earth
  ///  Draw the Moon
  void drawSpace(Canvas canvas, Size size) {
    final time = spaceClockTime;
    final config =
        overrideTheme ?? (isDark ? darkSpaceConfig : lightSpaceConfig);

    final viewModel = SpaceViewModel.of(time, config, size);

    // Draw the various layers, back to front
    drawBackground(canvas, size, viewModel);
    drawStars(canvas, size, viewModel.backgroundRotation,
        time.millisecondsSinceEpoch / 1000.0);

    drawSun(canvas, size, viewModel, config);

    //We draw the moon behind for the "top" pass of the circle
    if (time.second < 15 || time.second > 45) {
      drawMoon(canvas, size, viewModel, config);
      drawEarth(canvas, size, viewModel, config);
    } else {
      drawEarth(canvas, size, viewModel, config);
      drawMoon(canvas, size, viewModel, config);
    }
  }

  /// Draws the Background
  ///
  /// It's size is "big enough" to cover the screen
  /// it's centered and rotated at the same speed as the star layer
  ///
  ///
  void drawBackground(Canvas canvas, Size size, SpaceViewModel viewModel) =>
      _imageMap["stars"]?.drawRotatedSquare(
          canvas: canvas,
          size: viewModel.backgroundSize,
          offset: viewModel.centerOffset,
          rotation: viewModel.backgroundRotation,
          paint: standardPaint);

  /// Draw the Sun
  ///
  /// We have 4 Layers, we can draw them 8 times (flipped once)
  /// to increase randomness
  ///
  /// The layers are Blended/Transformed based on the kernels/arrays in the config
  /// This was just experimented with until I liked the way it looks
  ///
  /// The idea was to have it look bright and gaseous, with the occasional
  /// sunspot
  void drawSun(
      Canvas canvas, Size size, SpaceViewModel viewModel, SpaceConfig config) {
    sunBasePaint.shader = config.sunGradient.createShader(Rect.fromCircle(
        center: viewModel.sunOffset, radius: viewModel.sunBaseRadius));

    canvas.drawCircle(
        viewModel.sunOffset, viewModel.sunBaseRadius, sunBasePaint);

    //We are going to go through layers 1-3 twice, once flipped
    for (final layer in config.sunLayers) {
      sunLayerPaint.blendMode = layer.mode;
      _imageMap[layer.image]?.drawRotatedSquare(
          canvas: canvas,
          size: viewModel.sunSize,
          offset: viewModel.sunOffset,
          rotation: viewModel.sunRotation * layer.speed,
          paint: sunLayerPaint,
          flip: layer.flipped);
    }
  }

  ///
  /// Draws the Moon
  ///
  /// Most tweakable params should be accessible in the constants at the top
  ///
  /// We draw the moon, offset the earth, around it's rotation
  /// The shadow is calculated by looking at the suns position
  /// And figuring out the opposite angle.
  ///
  void drawMoon(
      Canvas canvas, Size size, SpaceViewModel viewModel, SpaceConfig config) {
    _imageMap["moon"]?.drawRotatedSquare(
        canvas: canvas,
        size: viewModel.moonSize,
        offset: viewModel.moonOffset,
        rotation: viewModel.moonRotation,
        paint: standardPaint);

    _imageMap["shadow"]?.drawRotatedSquare(
        canvas: canvas,
        size: viewModel.moonSize,
        offset: viewModel.moonOffset,
        rotation: viewModel.sunRotation,
        paint: standardPaint);
  }

  ///
  /// DrawEarth
  ///
  /// Draws the earth
  ///
  /// Draws the earth based on it's calculated position
  /// Shadow is drawn as a overlay, opposite the sun's position
  ///
  void drawEarth(
      Canvas canvas, Size size, SpaceViewModel viewModel, SpaceConfig config) {
    _imageMap["earth"]?.drawRotatedSquare(
        canvas: canvas,
        size: viewModel.earthSize,
        offset: viewModel.earthOffset,
        rotation: viewModel.earthRotation,
        paint: standardPaint);

    _imageMap["shadow"]?.drawRotatedSquare(
        canvas: canvas,
        size: viewModel.earthSize,
        offset: viewModel.earthOffset,
        rotation: viewModel.sunRotation,
        paint: standardPaint);
  }
}
