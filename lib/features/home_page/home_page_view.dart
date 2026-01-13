import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myapp/features/home_page/home_page_controller.dart';
import 'package:myapp/features/home_page/widgets/appbar.dart';
import 'package:myapp/navigation/routes_constant.dart';
import 'package:myapp/models/post.dart';
import '../../core/globals/global_variables.dart' as glbv;

class HomePageView extends GetView<HomePageController> {
  static const Color primaryTeal = Color(0xFF008080);
  static const Color darkTeal = Color(0xFF004D4D);
  static const Color lightTeal = Color(0xFFE0F7FA);
  static const Color accentTeal = Color(0xFF4DB6AC);
  static const Color luxuryGold = Color(0xFFD4AF37);
  static const Color luxuryGray = Color(0xFF2C2C2C);
  static const Color premiumWhite = Color(0xFFFAFAFA);

  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF004D4D), Color(0xFF002D2D)],
    stops: [0.0, 0.7],
  );

  static const Gradient luxuryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF004D4D), Color(0xFF002D2D)],
    stops: [0.0, 0.7],
  );

  static const Gradient accentGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF80CBC4), Color(0xFFE0F2F1)],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: premiumWhite,
      body: _buildBody(),
      drawer: _buildLuxuryDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreatePostDialog,
        backgroundColor: primaryTeal,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: luxuryGold.withOpacity(0.3), width: 1.5),
        ),
        icon: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.white, luxuryGold],
            ),
          ),
          child: const Icon(Iconsax.edit, size: 20),
        ),
        label: Text(
          'Create Post',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildLuxuryDrawer() {
    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: luxuryGradient,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 30,
              spreadRadius: 5,
              offset: const Offset(5, 0),
            ),
          ],
        ),
        child: Column(
          children: [

            // Premium Drawer Header
            Container(
              height: 240,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    darkTeal,
                    primaryTeal.withOpacity(0.9),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                boxShadow: [
                  BoxShadow(
                    color: luxuryGold.withOpacity(0.2),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
                border: Border(
                  bottom: BorderSide(
                    color: luxuryGold.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(),
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [primaryTeal, luxuryGold],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: luxuryGold.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Stack(
                      children: [
                        const Center(
                          child: Icon(
                            Iconsax.health,
                            color: Colors.white,
                            size: 44,
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: luxuryGold,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Iconsax.verify,
                              size: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "NaiviSense",
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Premium Healing Platform",
                    style: GoogleFonts.poppins(
                      color: luxuryGold,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2,
                    ),
                  ),

                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      darkTeal.withOpacity(0.98),
                      darkTeal.withOpacity(0.95),
                    ],
                  ),
                ),
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          _buildLuxuryMenuItem(
                            icon: Iconsax.chart_21,
                            title: "Dashboard",
                            subtitle: "Advanced Analytics & Insights",
                            isActive: true,
                            badge: "New",
                            onTap: () {
                              if(glbv.role == "patient") {
                                Get.toNamed(RoutesConstant.parentDashboard);
                              } else {
                                Get.toNamed(RoutesConstant.therapistDashboard);
                              }
                            },
                          ),
                          _buildLuxuryMenuItem(
                            icon: Iconsax.people,
                            title: "Healing Circle",
                            subtitle: "Premium Community Access",
                            onTap: () {},
                          ),
                          _buildLuxuryMenuItem(
                            icon: Iconsax.task_square,
                            title: "Tasks",
                            subtitle: "Personalized Task Management",
                            onTap: () {
                              Get.toNamed(RoutesConstant.taskPage);
                            },
                          ),
                          _buildLuxuryMenuItem(
                            icon: Iconsax.message_text_1,
                            title: "Conversation",
                            subtitle: "Secure Messaging",
                            badge: "3",
                            onTap: () {},
                          ),
                          _buildLuxuryMenuItem(
                            icon: Iconsax.calendar_2,
                            title: "Schedule",
                            subtitle: "Smart Scheduling System",
                            onTap: () {
                              Get.toNamed(RoutesConstant.schedulePage);
                            },
                          ),
                          _buildLuxuryMenuItem(
                            icon: Iconsax.setting_2,
                            title: "Settings",
                            subtitle: "Advanced Preferences",
                            onTap: () {
                              Get.toNamed(RoutesConstant.settingsPage);
                            },
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Logout Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    darkTeal.withOpacity(0.9),
                    darkTeal,
                  ],
                ),
                border: Border(
                  top: BorderSide(
                    color: luxuryGold.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: InkWell(
                onTap: () {
                  Get.offAllNamed(RoutesConstant.loginPage);
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.05),
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Colors.red.withOpacity(0.3),
                              Colors.red.withOpacity(0.1),
                            ],
                          ),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.4),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Iconsax.logout_1,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "LOG OUT",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const Spacer(),
                                Icon(
                                  Iconsax.arrow_right_3,
                                  color: Colors.white.withOpacity(0.6),
                                  size: 18,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Secure sign out",
                              style: GoogleFonts.poppins(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLuxuryMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    bool isActive = false,
    String? badge,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: isActive
                ? LinearGradient(
              colors: [
                primaryTeal.withOpacity(0.3),
                primaryTeal.withOpacity(0.1),
              ],
            )
                : null,
            border: Border.all(
              color: isActive
                  ? luxuryGold.withOpacity(0.3)
                  : Colors.transparent,
              width: isActive ? 1.5 : 0,
            ),
            boxShadow: isActive
                ? [
              BoxShadow(
                color: luxuryGold.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: isActive
                        ? [primaryTeal, luxuryGold]
                        : [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.05),
                    ],
                  ),
                  border: Border.all(
                    color: isActive
                        ? luxuryGold.withOpacity(0.5)
                        : Colors.white.withOpacity(0.2),
                    width: 2,
                  ),
                  boxShadow: isActive
                      ? [
                    BoxShadow(
                      color: luxuryGold.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                      : null,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                        if (badge != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: badge == "VIP"
                                  ? luxuryGold
                                  : badge == "New"
                                  ? Colors.green
                                  : primaryTeal,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              badge,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Iconsax.arrow_right_3,
                color: Colors.white.withOpacity(0.5),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return CustomScrollView(
      slivers: [
        const BuildSliverAppBar(),

        // Welcome Section
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryTeal.withOpacity(0.1),
                  lightTeal.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryTeal.withOpacity(0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primaryTeal.withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Iconsax.sun_1,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Good Morning,",
                            style: GoogleFonts.poppins(
                              color: luxuryGray.withOpacity(0.7),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Welcome to Your Healing Journey",
                            style: GoogleFonts.playfairDisplay(
                              color: darkTeal,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        lightTeal.withOpacity(0.5),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: luxuryGold.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Iconsax.health,
                                    color: primaryTeal,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  "Daily Progress",
                                  style: GoogleFonts.poppins(
                                    color: darkTeal,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "Complete your daily wellness exercises to unlock premium insights",
                              style: GoogleFonts.poppins(
                                color: luxuryGray.withOpacity(0.7),
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: primaryGradient,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: primaryTeal.withOpacity(0.3),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Iconsax.arrow_right_3,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Filter Chips
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.filters.length,
                itemBuilder: (context, index) {
                  final filter = controller.filters[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      right: 12,
                      left: index == 0 ? 0 : 0,
                    ),
                    child: Obx(
                          () => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: controller.selectedFilter.value == filter
                                ? Colors.transparent
                                : Colors.grey.shade200,
                            width: 1.5,
                          ),

                        ),
                        child: FilterChip(
                          selected: controller.selectedFilter.value == filter,
                          onSelected: (_) => controller.filterPosts(filter),
                          label: Text(
                            filter.replaceAll('_', ' ').toTitleCase(),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color:(controller.selectedFilter.value == filter)?Colors.white: Colors.black

                            ),
                          ),
                          selectedColor: darkTeal,
                          backgroundColor:  (controller.selectedFilter.value == filter)?Colors.teal: Colors.white,

                          side: BorderSide.none,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          showCheckmark: false,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),

        // const SizedBox(height: 20),

        // Create Post Card
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: _buildPremiumCreatePostCard(),
          ),
        ),

        // Posts List
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          sliver: (controller.isLoading.value)
              ? SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildPremiumShimmer(),
              childCount: 3,
            ),
          )
              : SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final post = controller.posts[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: PremiumPostCard(
                    userName: post.userName,
                    userProfile: post.userProfile,
                    post: post,
                    onLike: () => controller.toggleLike(post.id),
                    onComment: () => _showPremiumCommentsSheet(post),
                    onShare: () => controller.sharePost(post.id),
                  ),
                );
              },
              childCount: controller.posts.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumCreatePostCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: primaryGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: primaryTeal.withOpacity(0.3),
                        blurRadius: 15,
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Iconsax.user,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: _showCreatePostDialog,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: lightTeal.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.grey.shade100,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Share your healing journey...',
                              style: GoogleFonts.poppins(
                                color: luxuryGray.withOpacity(0.6),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Icon(
                            Iconsax.edit_2,
                            color: primaryTeal,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPremiumPostOption(
                  icon: Iconsax.gallery,
                  text: 'Gallery',
                  color: primaryTeal,
                ),
                _buildPremiumPostOption(
                  icon: Iconsax.video_circle,
                  text: 'Video',
                  color: Color(0xFF8B5CF6),
                ),
                _buildPremiumPostOption(
                  icon: Iconsax.document_text,
                  text: 'Article',
                  color: Color(0xFFF59E0B),
                ),
                _buildPremiumPostOption(
                  icon: Iconsax.activity,
                  text: 'Progress',
                  color: Color(0xFF10B981),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumPostOption({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: luxuryGray.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumShimmer() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Shimmer(
          baseColor: Colors.grey.shade100,
          highlightColor: Colors.grey.shade50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 140,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 100,
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 220,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreatePostDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 40,
                spreadRadius: 5,
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: primaryGradient,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Create Premium Post',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.2),
                          ),
                          child: const Icon(
                            Iconsax.close_circle,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        onPressed: () => Get.back(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: primaryGradient,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: primaryTeal.withOpacity(0.3),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Iconsax.user,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'You',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: luxuryGray,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: luxuryGold.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: luxuryGold.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Iconsax.global,
                                        size: 14,
                                        color: luxuryGold,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Premium Audience',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: luxuryGold,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: lightTeal.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.grey.shade100,
                            width: 1.5,
                          ),
                        ),
                        child: TextFormField(
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: 'Share your thoughts, achievements, or healing progress...',
                            hintStyle: GoogleFonts.poppins(
                              color: luxuryGray.withOpacity(0.5),
                            ),
                            border: InputBorder.none,
                          ),
                          style: GoogleFonts.poppins(
                            color: luxuryGray,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          _buildPremiumAttachmentButton(
                            icon: Iconsax.gallery_add,
                            color: primaryTeal,
                          ),
                          const SizedBox(width: 12),
                          _buildPremiumAttachmentButton(
                            icon: Iconsax.video_add,
                            color: Color(0xFF8B5CF6),
                          ),
                          const SizedBox(width: 12),
                          _buildPremiumAttachmentButton(
                            icon: Iconsax.location,
                            color: Color(0xFF10B981),
                          ),
                          const SizedBox(width: 12),
                          _buildPremiumAttachmentButton(
                            icon: Iconsax.emoji_happy,
                            color: Color(0xFFF59E0B),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Get.back(),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                side: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                'Cancel',
                                style: GoogleFonts.poppins(
                                  color: luxuryGray.withOpacity(0.7),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Create post logic here
                                Get.back();
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                backgroundColor: primaryTeal,
                                shadowColor: primaryTeal.withOpacity(0.3),
                                elevation: 8,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Iconsax.send_2,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Publish',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.5),
    );
  }

  Widget _buildPremiumAttachmentButton({
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: Icon(
        icon,
        color: color,
        size: 22,
      ),
    );
  }

  void _showPremiumCommentsSheet(Post post) {
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(Get.context!).size.height * 0.85,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 40,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: primaryGradient,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Comments',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${post.comments} premium responses',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: const Icon(
                        Iconsax.close_circle,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(24),
                itemCount: 5, // Mock comments
                itemBuilder: (context, index) {
                  return _buildPremiumCommentItem();
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade100,
                    width: 1.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Iconsax.user,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: lightTeal.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Colors.grey.shade100,
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Add a premium comment...',
                                hintStyle: GoogleFonts.poppins(
                                  color: luxuryGray.withOpacity(0.5),
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              gradient: primaryGradient,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: primaryTeal.withOpacity(0.3),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Iconsax.send_2,
                                color: Colors.white,
                                size: 18,
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      enableDrag: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildPremiumCommentItem() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade100,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF8B5CF6),
                  Color(0xFF10B981),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'AJ',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Alex Johnson',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: luxuryGray,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: luxuryGold.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: luxuryGold.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'VIP',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: luxuryGold,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '2h ago',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: luxuryGray.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'This is incredibly inspiring! Your progress showcases the power of dedication to healing. Keep shining!',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: luxuryGray.withOpacity(0.8),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Iconsax.heart,
                          size: 16,
                          color: Colors.red,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '24',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: luxuryGray.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: primaryTeal.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Iconsax.message,
                          size: 16,
                          color: primaryTeal,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Reply',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: primaryTeal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Premium Post Card
class PremiumPostCard extends StatelessWidget {
  final String userName;
  final String userProfile;
  final Post post;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;

  const PremiumPostCard({
    super.key,
    required this.userName,
    required this.userProfile,
    required this.post,
    required this.onLike,
    required this.onComment,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Premium Badge
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: _getRoleGradient(post.userRole),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          userProfile.substring(0, 1).toUpperCase(),
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                userName,
                                style: GoogleFonts.poppins(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: HomePageView.luxuryGray,
                                ),
                              ),

                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getRoleColor(post.userRole).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: _getRoleColor(post.userRole).withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  post.userRole.replaceAll('_', ' ').toTitleCase(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: _getRoleColor(post.userRole),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Iconsax.clock,
                                size: 12,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${post.createdAt}',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
                // Tags
                if (post.tags != null && post.tags!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: post.tags!.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: HomePageView.lightTeal.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: HomePageView.primaryTeal.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Iconsax.hashtag,
                                size: 12,
                                color: HomePageView.primaryTeal,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${tag.replaceAll('_', ' ')}',
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: HomePageView.primaryTeal,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              post.contentText,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: HomePageView.luxuryGray.withOpacity(0.9),
                height: 1.7,
              ),
            ),
          ),

          // Images Grid
          if (post.images != null && post.images!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 24, right: 24),
              child: Container(
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.grey.shade50,
                      Colors.grey.shade100,
                    ],
                  ),
                  border: Border.all(
                    color: Colors.grey.shade200,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child:SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [...post.images!.map((imgurl)=>
                        CachedNetworkImage(imageUrl: imgurl,fit: BoxFit.contain,),
                      )],
                    ),
                  ),
                ),
              ),
            ),

          // Stats & Actions
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Stats Bar
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: HomePageView.lightTeal.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: Colors.grey.shade100,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem(
                        icon: Iconsax.heart,
                        value: '${post.likes}',
                        label: 'Likes',
                        color: Colors.red,
                        isActive: post.isLiked,
                      ),
                      _buildStatItem(
                        icon: Iconsax.message,
                        value: '${post.comments}',
                        label: 'Comments',
                        color: HomePageView.primaryTeal,
                        isActive: false,
                      ),
                      _buildStatItem(
                        icon: Iconsax.share,
                        value: '${post.shares}',
                        label: 'Shares',
                        color: Colors.blue,
                        isActive: false,
                      ),
                      _buildStatItem(
                        icon: Iconsax.eye,
                        value: '1.2K',
                        label: 'Views',
                        color: Colors.purple,
                        isActive: false,
                      ),
                    ],
                  ),
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required bool isActive,
  }) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isActive ? color.withOpacity(0.1) : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? color.withOpacity(0.3) : Colors.grey.shade200,
              width: 1.5,
            ),
            boxShadow: [
              if (isActive)
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 10,
                ),
            ],
          ),
          child: Icon(
            icon,
            color: isActive ? color : Colors.grey.shade400,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: HomePageView.luxuryGray,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
    bool isSmall = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSmall ? 0 : 16,
          vertical: isSmall ? 0 : 14,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? HomePageView.primaryTeal.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive
                ? HomePageView.primaryTeal.withOpacity(0.3)
                : Colors.grey.shade200,
            width: 1.5,
          ),
        ),
        child: isSmall
            ? Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.grey.shade600,
            size: 20,
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive
                  ? HomePageView.primaryTeal
                  : Colors.grey.shade600,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive
                    ? HomePageView.primaryTeal
                    : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Gradient _getRoleGradient(String role) {
    switch (role) {
      case 'therapist':
        return const LinearGradient(
          colors: [Color(0xFF0D9488), Color(0xFF2DD4BF)],
        );
      case 'patient':
        return const LinearGradient(
          colors: [Color(0xFF4A90E2), Color(0xFF6AB1F4)],
        );
      case 'therapy_center':
        return const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF64748B), Color(0xFF94A3B8)],
        );
    }
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'therapist':
        return const Color(0xFF0D9488);
      case 'patient':
        return const Color(0xFF4A90E2);
      case 'therapy_center':
        return const Color(0xFF8B5CF6);
      default:
        return const Color(0xFF64748B);
    }
  }
}

// Shimmer Effect
class Shimmer extends StatelessWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;

  const Shimmer({
    super.key,
    required this.child,
    this.baseColor = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

extension StringExtension on String {
  String toTitleCase() {
    return split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}