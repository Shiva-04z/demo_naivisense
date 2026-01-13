import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildBackground extends StatelessWidget {
  static const Color primaryTeal = Color(0xFF008080);
  static const Color darkTeal = Color(0xFF006666);
  static const Color lightTeal = Color(0xFFE0F2F1);
  static const Color accentTeal = Color(0xFF4DB6AC);
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF008080), Color(0xFF4DB6AC)],
  );

  const BuildBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            darkTeal,
            primaryTeal,
            accentTeal.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.5, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Stack(
        children: [
          // Main background pattern
          CustomPaint(
            painter: _TealBackgroundPainter(),
          ),

          // Subtle gradient overlay for depth
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.03),
                  Colors.transparent,
                  Colors.black.withOpacity(0.02),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Subtle noise texture
          CustomPaint(
            painter: _NoiseTexturePainter(),
          ),
        ],
      ),
    );
  }
}

class _TealBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 20);

    // Large organic shapes for depth
    final largeCirclePath = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(size.width * 0.2, size.height * 0.3),
        radius: size.width * 0.2,
      ));
    canvas.drawPath(largeCirclePath, paint);

    // Secondary organic shape
    final secondaryCirclePath = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(size.width * 0.75, size.height * 0.65),
        radius: size.width * 0.15,
      ));
    canvas.drawPath(secondaryCirclePath, paint);

    // Smaller accent shapes
    paint.color = Colors.white.withOpacity(0.05);
    paint.maskFilter = MaskFilter.blur(BlurStyle.normal, 15);

    canvas.drawCircle(
      Offset(size.width * 0.4, size.height * 0.8),
      size.width * 0.12,
      paint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.6, size.height * 0.2),
      size.width * 0.08,
      paint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.85, size.height * 0.15),
      size.width * 0.06,
      paint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.7),
      size.width * 0.07,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _NoiseTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.02)
      ..style = PaintingStyle.fill;

    // Create subtle noise effect
    for (int i = 0; i < 200; i++) {
      final x = size.width * Random().nextDouble();
      final y = size.height * Random().nextDouble();
      final radius = 1 + Random().nextDouble() * 3;

      canvas.drawCircle(
        Offset(x, y),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Helper Random class for noise generation
class Random {
  static final _random = math.Random();

  double nextDouble() => _random.nextDouble();
}

// Optional: Additional decorative elements
class BuildBackgroundWithPatterns extends StatelessWidget {
  final Widget child;

  const BuildBackgroundWithPatterns({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BuildBackground(),

        // Geometric pattern overlay
        Positioned.fill(
          child: CustomPaint(
            painter: _GeometricPatternPainter(),
          ),
        ),

        // Main content
        child,
      ],
    );
  }
}

class _GeometricPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Create a subtle grid pattern
    final gridSpacing = 40.0;

    // Vertical lines
    for (double x = 0; x < size.width; x += gridSpacing) {
      final path = Path()
        ..moveTo(x, 0)
        ..lineTo(x, size.height);
      canvas.drawPath(path, paint);
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += gridSpacing) {
      final path = Path()
        ..moveTo(0, y)
        ..lineTo(size.width, y);
      canvas.drawPath(path, paint);
    }

    // Add some subtle dots at intersections
    paint.style = PaintingStyle.fill;
    paint.color = Colors.white.withOpacity(0.05);

    for (double x = 0; x < size.width; x += gridSpacing) {
      for (double y = 0; y < size.height; y += gridSpacing) {
        if ((x ~/ gridSpacing + y ~/ gridSpacing) % 3 == 0) {
          canvas.drawCircle(
            Offset(x, y),
            1.5,
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Alternative: Gradient Background with Waves
class TealWaveBackground extends StatelessWidget {
  const TealWaveBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            BuildBackground.darkTeal,
            BuildBackground.primaryTeal,
            BuildBackground.accentTeal,
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
      ),
      child: CustomPaint(
        painter: _WavePainter(),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 15);

    // Create wave-like shapes
    final wave1 = Path()
      ..moveTo(0, size.height * 0.3)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.25,
        size.width * 0.5,
        size.height * 0.3,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.35,
        size.width,
        size.height * 0.3,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(wave1, paint);

    // Second wave
    paint.color = Colors.white.withOpacity(0.07);

    final wave2 = Path()
      ..moveTo(0, size.height * 0.6)
      ..quadraticBezierTo(
        size.width * 0.33,
        size.height * 0.55,
        size.width * 0.66,
        size.height * 0.6,
      )
      ..quadraticBezierTo(
        size.width * 0.8,
        size.height * 0.65,
        size.width,
        size.height * 0.6,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(wave2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}