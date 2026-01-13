import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myapp/features/login_page/login_page_controller.dart';
import 'package:myapp/features/login_page/widgets/form_body.dart';
import 'package:myapp/features/splash_page/widgets/background.dart';

class LoginPageView extends GetView<LoginPageController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BuildBackground(),
          Center(
            child: FadeInUp(
              duration: const Duration(milliseconds: 1000),
              child: const FormBody(),
            ),
          ),
          // Back button
          Positioned(
            top: 50,
            left: 20,
            child: FadeInLeft(
              duration: const Duration(milliseconds: 800),
              child: IconButton(
                icon: const Icon(
                  Iconsax.arrow_left_2,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () => Get.back(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}