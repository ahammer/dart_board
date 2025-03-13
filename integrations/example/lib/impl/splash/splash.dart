import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:dart_board_canvas/dart_board_canvas.dart';
import 'package:dart_board_core/dart_board_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExampleSplashWidget extends StatelessWidget {
  const ExampleSplashWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (ctx, constraints) => Stack(
          children: [
            RouteWidget('/space'),
            RouteWidget('/splash_animation'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Dart Board',
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 15,
                            offset: Offset(3, 3))
                      ]),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: MaterialButton(
                  color: Colors.blue.withOpacity(0.5),
                  onPressed: () {
                    context.dispatchMethod('hideSplashScreen');
                  },
                  child: Text(
                    'Continue',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      );
}

/// Continuous motion logo animation based on theta concept
class SplashAnimation extends AnimatedCanvasState {
  // Logo image for direct pixel sampling
  ui.Image? logoImage;
  bool imageLoaded = false;
  ByteData? imageData;
  
  // Store our particles
  final List<LogoParticle> particles = [];
  
  // Animation parameters
  final double totalDuration = 5.0;   // Total animation duration in seconds
  final double peakTime = 2.5;        // Time at which the logo is fully formed
  final double pinchRange = 0.2;      // Range around 0 for strongest pinch
  final double pinchFactor = 6.0;     // Controls the strength of the pinch effect
  final double waveBaseAmplitude = 0.015; // Base amplitude for wave functions
  final double explosionScale = 50.0; // Much larger explosion factor - particles travel to infinity
  
  // Cubic function parameters for smooth animation
  final double cubicInfluence = 0.8;  // How strong the cubic slowdown is at midpoint
  final double midPointWidth = 0.15;  // Width of the gentle "hang" region
  
  // Wave constants for rich motion
  // These add complexity to the motion patterns
  final List<double> waveFrequencies = [
    0.9, 1.7, 2.3, 3.1, 4.3, 5.7, 7.9
  ];
  final List<double> wavePhases = [];
  
  // Background fade timing
  final double bgFadeStartTime = 3.5;
  final double bgFadeDuration = 0.8;
  
  // Random generator
  final math.Random random = math.Random();
  
  @override
  void init(BuildContext context) {
    super.init(context);
    
    // Initialize random wave phases for each frequency
    wavePhases.clear();
    for (int i = 0; i < waveFrequencies.length; i++) {
      wavePhases.add(random.nextDouble() * math.pi * 2);
    }
    
    _loadLogoImage();
  }
  
  // Load the logo image for direct pixel sampling
  Future<void> _loadLogoImage() async {
    try {
      final ByteData data = await rootBundle.load('assets/db_64.png');
      final Uint8List bytes = data.buffer.asUint8List();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      
      logoImage = frame.image;
      
      // Get pixel data for accurate color sampling
      imageData = await logoImage!.toByteData(format: ui.ImageByteFormat.rawRgba);
      imageLoaded = true;
      
      // Create particles from actual image pixels
      _createParticlesFromImage();
    } catch (e) {
      print('Error loading logo image: $e');
    }
  }
  
  // Calculate theta using a smoother function with better "in" animation
  double _calculateTheta() {
    // Normalize time to 0-1 range
    final t = math.min(time / totalDuration, 1.0);
    
    // Handle the first half (in) and second half (out) differently
    if (t < 0.5) {
      // For the "in" part, use a simple linear-to-cubic blend
      // This gives a more predictable and smooth "in" motion
      final inProgress = t * 2.0; // Scale to 0-1
      
      // Start with linear approach
      final linearPart = inProgress;
      
      // Blend with cubic ease-in for final approach
      final cubicPart = Curves.easeInCubic.transform(inProgress);
      
      // Blend more heavily toward cubic as we approach center
      final blend = 0.7 * linearPart + 0.3 * cubicPart;
      
      // Map to -1 to 0 range
      return -1.0 + blend;
    } else {
      // For the "out" part, use an exponential acceleration
      // This gives the dramatic "to infinity" effect
      final outProgress = (t - 0.5) * 2.0; // Scale to 0-1
      
      // Use Curves.easeInExpo for dramatic acceleration
      return Curves.easeInQuint.transform(outProgress);
    }
  }
  
  // Create particles for each non-transparent pixel in the image
  void _createParticlesFromImage() {
    if (!imageLoaded || logoImage == null || imageData == null) {
      return;
    }
    
    final int width = logoImage!.width;
    final int height = logoImage!.height;
    
    particles.clear();
    
    // Process each pixel in the image
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        // Calculate the pixel index (4 bytes per pixel - RGBA)
        final int pixelIndex = (y * width + x) * 4;
        
        // Read the RGBA values
        final int r = imageData!.getUint8(pixelIndex);
        final int g = imageData!.getUint8(pixelIndex + 1);
        final int b = imageData!.getUint8(pixelIndex + 2);
        final int a = imageData!.getUint8(pixelIndex + 3);
        
        // Skip fully transparent pixels
        if (a < 10) continue;
        
        // Create normalized UV coordinates (-1 to 1)
        // Flip Y to match normal coordinate system (negative is up)
        final double uvX = (x / width) * 2 - 1;
        final double uvY = -((y / height) * 2 - 1);
        
        // Generate random base frequency multipliers for this particle
        final List<double> frequencyMultipliers = List.generate(
          waveFrequencies.length, 
          (_) => 0.8 + random.nextDouble() * 0.4
        );
        
        // Create a particle for this pixel - much smaller particles for higher density
        particles.add(LogoParticle(
          anchor: Offset(uvX, uvY) * 0.5, // Half the size for more density
          color: Color.fromARGB(a, r, g, b),
          size: 0.002 + random.nextDouble() * 0.001, // Much smaller particles
          frequencyMultipliers: frequencyMultipliers,
          // Each particle gets unique wave amplitudes for more organic motion
          waveAmplitudes: List.generate(
            waveFrequencies.length, 
            (i) => waveBaseAmplitude * (1.0 + random.nextDouble() * 0.5) / (i + 1)
          ),
          // Add unique explosion direction vector for more varied explosion
          explosionDirection: Offset(
            random.nextDouble() * 2 - 1,  // Random x direction
            random.nextDouble() * 2 - 1   // Random y direction
          ),
          // Random explosion multiplier for varied explosion distances
          explosionMultiplier: 0.5 + random.nextDouble() * 1.5,
        ));
      }
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (particles.isEmpty) {
      // If no particles yet, try creating them (useful for hot reload)
      if (imageLoaded && logoImage != null && imageData != null) {
        _createParticlesFromImage();
      } else {
        // Still loading
        return;
      }
    }
    
    final longestSide = math.max(size.width, size.height);
    
    // Calculate theta - now follows a non-repeating curve from -1 to 1
    // with 0 being the fully formed logo state
    final theta = _calculateTheta();
    
    // Apply background fade when approaching the end
    if (time > bgFadeStartTime && time < bgFadeStartTime + bgFadeDuration) {
      final bgOpacity = 1.0 - (time - bgFadeStartTime) / bgFadeDuration;
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = Colors.black.withOpacity(bgOpacity * 0.3),
      );
    }
    
    // Draw all particles
    for (var particle in particles) {
      _drawParticle(canvas, size, particle, theta, longestSide);
    }
  }
  
  void _drawParticle(Canvas canvas, Size size, LogoParticle particle, double theta, double longestSide) {
    canvas.save();
    
    // The closer theta is to 0, the more stable the particles should be
    // Calculate distance from stable point (theta = 0)
    final distanceFromStable = theta.abs();
    
    // Apply pinch effect - particles move slower near the stable point
    // This creates a natural pause at the fully formed logo state
    double velocityScale;
    if (distanceFromStable < pinchRange) {
      // Slow down particles near the stable point (theta = 0)
      // This creates a curve that approaches zero as theta approaches zero
      velocityScale = math.pow(distanceFromStable / pinchRange, pinchFactor).toDouble();
    } else {
      // Beyond the pinch range, scale velocity more linearly
      velocityScale = 1.0;
    }
    
    // Start with anchor position
    Offset position = particle.anchor;
    
    // Apply compound wave displacement scaled by distance from stable point
    Offset displacement = Offset.zero;
    for (int i = 0; i < waveFrequencies.length; i++) {
      final frequency = waveFrequencies[i] * particle.frequencyMultipliers[i];
      final phase = wavePhases[i];
      final amplitude = particle.waveAmplitudes[i];
      
      // Complex wave pattern with theta as input
      final wave = math.sin(theta * frequency + phase + particle.anchor.dx * 3) * 
                  math.cos(theta * frequency * 0.7 + phase + particle.anchor.dy * 3);
      
      // Apply to both dimensions for complex motion
      displacement += Offset(
        wave * amplitude * (i % 2 == 0 ? 1 : 0.7),  // X gets full amplitude on even frequencies
        wave * amplitude * (i % 2 == 1 ? 1 : 0.7)   // Y gets full amplitude on odd frequencies
      );
    }
    
    // Apply the displacement scaled by distance from stable
    // Use a much higher explosion factor for the particles to travel "off to infinity"
    double scaleFactor;
    if (theta < 0) {
      // Coming in - use absolute scale for less janky motion
      scaleFactor = 8.0; // Constant scale to make "in" animation smoother
    } else {
      // Going out - exponential scale based on theta with individual particle variation
      // This creates dramatically increasing speed as particles travel outward
      final progress = theta;
      // Use particle's unique explosion multiplier for more randomized explosion pattern
      scaleFactor = explosionScale * particle.explosionMultiplier * 
                    math.pow(1.0 + progress * 1.2, 3).toDouble();
      
      // Apply particle's unique explosion direction for varied movement
      position += particle.explosionDirection * progress * progress * scaleFactor * 0.2;
    }
    
    position += displacement * distanceFromStable * scaleFactor;
    
    // Calculate opacity - fully opaque when theta is near 0, fading as it moves away
    double opacity = 1.0 - (distanceFromStable * 0.8);
    opacity = math.max(0.0, math.min(1.0, opacity));
    
    // Calculate particle size with subtle breathing effect
    double particleSize = particle.size * (1.0 + math.sin(time * 2) * 0.05);
    
    // Transform to screen coordinates
    final screenX = position.dx * longestSide * 0.4 + size.width / 2;
    final screenY = position.dy * longestSide * 0.4 + size.height / 2;
    
    // Draw the particle
    if (opacity > 0) {
      final particlePaint = Paint()
        ..color = particle.color.withOpacity(opacity)
        ..style = PaintingStyle.fill
        ..blendMode = BlendMode.srcOver;
        
      canvas.drawCircle(
        Offset(screenX, screenY),
        particleSize * longestSide,
        particlePaint
      );
    }
    
    canvas.restore();
  }
}

/// Individual particle in the continuous theta-based animation
class LogoParticle {
  final Offset anchor;           // The stable position (theta = 0)
  final Color color;             // Color from image sampling
  final double size;             // Base particle size
  
  // Wave properties for compound motion
  final List<double> frequencyMultipliers; // Unique multipliers for each frequency
  final List<double> waveAmplitudes;      // Amplitude for each wave component
  
  // Explosion properties for randomized outward movement
  final Offset explosionDirection;    // Unique direction for explosion
  final double explosionMultiplier;   // Individual scale factor for explosion distance
  
  LogoParticle({
    required this.anchor,
    required this.color,
    required this.size,
    required this.frequencyMultipliers,
    required this.waveAmplitudes,
    this.explosionDirection = const Offset(0, 0),
    this.explosionMultiplier = 1.0,
  });
}

// Helper function to convert from hsv to rgb color
Color hsvToColor(double h, double s, double v, [double a = 1.0]) {
  // Ensure h is in the range [0, 360)
  h = h % 360;
  if (h < 0) h += 360;
  
  // Normalize s and v to [0, 1]
  s = math.max(0.0, math.min(1.0, s));
  v = math.max(0.0, math.min(1.0, v));
  
  // Formula for converting HSV to RGB
  final c = v * s;
  final x = c * (1 - (((h / 60) % 2) - 1).abs());
  final m = v - c;
  
  double r = 0, g = 0, b = 0;
  
  if (h < 60) {
    r = c; g = x; b = 0;
  } else if (h < 120) {
    r = x; g = c; b = 0;
  } else if (h < 180) {
    r = 0; g = c; b = x;
  } else if (h < 240) {
    r = 0; g = x; b = c;
  } else if (h < 300) {
    r = x; g = 0; b = c;
  } else {
    r = c; g = 0; b = x;
  }
  
  final int red = ((r + m) * 255).round();
  final int green = ((g + m) * 255).round();
  final int blue = ((b + m) * 255).round();
  final int alpha = (a * 255).round();
  
  return Color.fromARGB(alpha, red, green, blue);
}

/* Commenting out for now as it has errors
/// Funvas-inspired test component (keeping for reference)
class FunvasApiTest extends AnimatedCanvasState {
  @override
  void paint(Canvas canvas, Size size) {
    c.drawPaint(Paint()..color = const Color(0xffffffff));
    final s = s2q(750), w = s.width, h = s.height;

    for (var A = .0, q = 123, j = .0, i = 756;
        i-- > 0;
        c.drawRect(
      Rect.fromLTWH(w / 2 + A * math.sin(j), h / 2 + A * math.cos(j), i / 84, i / 84),
      Paint()..color = Color.fromRGBO(i % 99 + 156, q - i % q, q, 1),
    )) {
      j = i / 9;
      A = (9 * math.sin(t * j / 20) + math.cos(20 * j) + 6) * 21;
    }
  }
}
*/
