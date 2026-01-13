import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:myapp/features/splash_page/splash_page_controller.dart';
import 'package:myapp/features/splash_page/widgets/background.dart';
import 'package:myapp/features/splash_page/widgets/title.dart';

class SplashPageView extends GetView<SplashPageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BuildBackground(),
          Center(
            child: FadeInRight(
              duration: const Duration(milliseconds: 1200),
              child: const BuildTitle(),
            ),
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: FadeInUp(
              delay: const Duration(milliseconds: 800),
              child: Text(
                controller.version,
                style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}