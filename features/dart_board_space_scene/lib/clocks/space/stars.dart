import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import '../../util/extensions.dart';

/*
✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨
🌠🌠🌠🌠🌠🌠🌠🌠🌠🌠🌠🌠🌠🌠🌠🌠🌠🌠🌠🌠🌠🌠
🌠
🌠 The StarField portion of the Space Clock
🌠 
🌠 This is really basic and performance minded
🌠 I want to be able to draw a starfield on a canvas.
🌠 
🌠 The interface is very simple. From a CustomPainter
🌠 call
🌠 
🌠 drawStars(canvas, size, rotation, time)
🌠 
🌠🌠🌠🌠🌠🌠🌠🌠🌠🌠🌠🌠🌠🌠🌠🌠🌠🌠🌠🌠🌠🌠
✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨✨
*/

// ============== 📖📒 Constants 📒📖 ==============

// Random Numbers
final _random = Random();

/// The default number of stars we will generate
const kNumberStars = 500;

/// 🔬 The "resolution" of the starfield render batching
/// N = number of draw calls to draw stars
/// N = the number of transitions of opacity we do from
///     near to far
const kSteps = 16; //16 is fast enough, yet doesn't really show much stepping

/// Precalculated step size
const kStepSize = 1.0 / kSteps;

/// ⏱️ Star Travel Time
///
/// At 1, stars travel 0-1 range every 1 second.
/// At 20, it'll take 20s for 0-1 to iterate
///
/// This number represents the # of seconds
/// a star will take to travel from back to front.
///
const kStarTravelTime = 25;

// 🎨 The paint for our stars
final Paint _starsPaint = Paint();

// 🌠 The actual stars
final List<Star> _stars = List.generate(kNumberStars, (idx) => Star());

/// 🌠 Star
/// Represents a Star
///
/// We only track X/Y/Z
/// The star itself is immutable
///
/// We are the ones that travel in this calculation.
///
class Star {
  /// x Coord of a random star (-0.5->0.5 means less transforms later)
  final double x = _random.nextDouble() - 0.5;

  /// y coord of a random star (-0.5->0.5 means less transforms later)
  final double y = _random.nextDouble() - 0.5;

  /// z coord of a random star
  final double z = _random.nextDouble();

  /// 🌐 zForTime(time)
  ///
  /// Gives a Z position adjusted for our time
  /// Z is always between (0 .. 1)
  /// We subtract time from this, and take the fraction.
  /// So a star at 0.5, after 10 seconds would be at -9.5.
  /// We then take the fraction and it's back at -0.5;
  ///
  double zForTime(double time) => (z - (time / kStarTravelTime)).fraction();

  /// 🌐 Project(time, perspective)
  ///
  /// Takes the 3D point and Projects it to 2D space for Time and Perspective
  /// Screen Space translation is handled on the other side
  ///
  /// Psuedo:
  ///   Make Vector3(x,y,zForTime)
  ///   Apply Projection to Vector
  ///   Convert to Offset (discard Z)
  ///
  Offset project(double time, vector.Matrix4 perspective) =>
      (vector.Vector3(x, y, zForTime(time))..applyProjection(perspective))
          .toOffset();
}

/// 📲 Draw Stars
///
/// We draw this starfield
///   canvas - on the Canvas
///   size - with a size
///   rotation - and a rotation around center
///   time - at a specific time
///
/// It fills the canvas
void drawStars(Canvas canvas, Size size, double rotation, double time) {
  /// 📷 Creates a 140 degree projection matrix for our size,
  /// with a near of 0 and a far of 1
  /// and rotates around the Z axis by rotation degrees
  final projection = vector.makePerspectiveMatrix(
      140, size.width / size.height, 0, 1)
    ..rotateZ(rotation);

  /// 🧮 Generates a "page" of stars (back to front) of varying opacities
  /// We draw pages to minimize draw calls
  /// E.g.
  ///   1 Draw Call = Single Paint, all stars look the same
  ///   1 Draw Call for 1,000 stars = slow, inefficient
  ///   Solution: Create kSteps/pages and draw each page with a common
  ///   paint back to front (painters algorithm)
  ///   This allows me to artistically handle distance variations
  ///   without tanking performance.

  final intervals = List.generate(kSteps, (idx) => idx / kSteps.toDouble());
  for (final interval in intervals) {
    /// 🎨 Generate star color based on the current page
    /// We fade the opacity with distance to camera
    ///
    /// We also adjust the size based on distance (between 1-2 px)
    _starsPaint
      ..color = Colors.white.withOpacity(1 - interval)
      ..strokeWidth = (1 - interval) + 1.5;

    // 🖌️ Draw the points
    canvas.drawPoints(
        PointMode.points,
        _stars
            // ✂️ where star Z is in current interval
            .where((star) => star
                .zForTime(time)
                .chain((z) => z > interval && z < (interval + kStepSize)))
            // 📺 Convert this Star into a Screen Space Offset
            .map((star) => star
                .project(time, projection) // Project to screen space
                .translate(
                    0.5, 0.5) // Transform it from -0.5->0.5 range to 0-1 range
                .scale(size.width,
                    size.height)) // Scale it from 0-1 range to canvas size
            //Creates a List<Offset> to draw, from all stars
            .toList(),
        _starsPaint);
  }
}
