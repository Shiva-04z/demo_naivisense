import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class BuildTitle extends StatelessWidget {
  const BuildTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Enhanced Icon Container
          FadeInDown(
            duration: const Duration(milliseconds: 1000),
            child: Container(
              height: 140,
              width: 140,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF4A90E2),
                    Color(0xFF50C9C3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A90E2).withOpacity(0.4),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Iconsax.activity, // Iconsax alternative for spa
                color: Colors.white,
                size: 70,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Enhanced Title
          FadeInUp(
            duration: const Duration(milliseconds: 1200),
            delay: const Duration(milliseconds: 200),
            child: Text(
              "NaiviSense",
              style: GoogleFonts.poppins(
                fontSize: 48,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 1.2,
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.3),
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Optional Subtitle
          FadeInUp(
            duration: const Duration(milliseconds: 1200),
            delay: const Duration(milliseconds: 400),
            child: Text(
              "Intuitive Navigation",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: Colors.white.withOpacity(0.8),
                letterSpacing: 3,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Enhanced Loading Animation
          FadeInUp(
            duration: const Duration(milliseconds: 1400),
            delay: const Duration(milliseconds: 600),
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: const Color(0xFF50C9C3),
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}
class AppColors {
  static const Color primary = Color(0xFF4A90E2);
  static const Color secondary = Color(0xFF50C9C3);
  static const Color accent = Color(0xFF9CECFB);
  static const Color darkBg = Color(0xFF0F2027);
  static const Color darkCard = Color(0xFF203A43);
  static const Color oceanBlue = Color(0xFF2C5364);
  static const Color lightText = Color(0xFFF5F5F5);
  static const Color mutedText = Color(0xFFA0A0A0);

  // Gradient variations
  static List<Color> get primaryGradient => [primary, secondary];
  static List<Color> get darkGradient => [darkBg, darkCard, oceanBlue];
}