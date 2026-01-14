import 'dart:ui' as ui;
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:myapp/features/therapist_profile/therapist_profile_controller.dart';
import 'package:myapp/models/user.dart';
import '../../core/globals/dummy_data.dart';
import '../../core/globals/global_variables.dart' as glbv;

class TherapistProfileView extends GetView<TherapistProfileController> {
  // Color definitions
  static const Color primaryTeal = Color(0xFF008080);
  static const Color accentTeal = Color(0xFF4DB6AC);
  static const Color lightTeal = Color(0xFFE0F2F1);
  static const Color darkTeal = Color(0xFF004D40);
  static const Color secondaryPurple = Color(0xFF7E57C2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() => (controller.isLoading.value)
          ? LoadingAnimationWidget.hexagonDots(
        color: Colors.teal.shade900,
        size: 32,
      )
          : CustomScrollView(
        slivers: <Widget>[
          // App Bar Sliver
          SliverAppBar(
            expandedHeight: 425,
            collapsedHeight: 70,
            pinned: true,
            floating: true,
            elevation: 0,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildProfileHeader(),
              collapseMode: CollapseMode.pin,
            ),
            actions: [
              IconButton(
                icon: Icon(Iconsax.more, color: darkTeal),
                onPressed: _showMoreOptions,
              ),
            ],
          ),

          // Action Buttons Section
          SliverToBoxAdapter(
            child: FadeInLeft(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildActionButton(
                        icon: Iconsax.link,
                        text: 'Connect',
                        color: primaryTeal,
                        onTap: controller.connectWithUser,
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: _buildActionButton(
                        icon: Iconsax.messages,
                        text: 'Talk TO AI',
                        color: darkTeal,
                        onTap: controller.bookAppointment,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Main Tab Bar
          SliverPersistentHeader(
            delegate: _MainTabBarDelegate(
              tabController: controller.mainTabController,
              onTabChanged: controller.changeMainTab,
            ),
            pinned: true,
          ),

          // Tab Content
          SliverToBoxAdapter(
            child: SizedBox(
              height: 600,
              child: TabBarView(
                controller: controller.mainTabController,
                children: [
                  _buildOverviewTab(),
                  _buildPostsTab(),
                  _buildJourneyTab(),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }

  // ... (Keep all existing methods: _buildProfileHeader, _buildStatItem,
  // _buildActionButton, _showMoreOptions, _buildActionTile, _buildOverviewTab,
  // _buildSpecializationChip, _buildWorkingHours, _buildPostsTab) until _buildTimelineTab...
  Widget _buildProfileHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [lightTeal.withOpacity(0.3), Colors.transparent],
        ),
      ),
      child: Stack(
        children: [
          // Background Pattern
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [primaryTeal.withOpacity(0.05), Colors.transparent],
                  radius: 0.7,
                ),
              ),
            ),
          ),

          Column(
            children: [
              SizedBox(height: 50),
              // Profile Image with Badge
              Stack(
                children: [
                  ZoomIn(
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: primaryTeal.withOpacity(0.2),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(65),
                        child: CachedNetworkImage(
                          imageUrl:
                          'https://i.pravatar.cc/300?u=${controller.userProfile?.id}',
                          placeholder: (context, url) => Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [primaryTeal, accentTeal],
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Iconsax.user,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [primaryTeal, accentTeal],
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Iconsax.user,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal.withOpacity(0.3),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Icon(
                        Iconsax.verify,
                        color: Colors.teal,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Name & Title
              FadeInUp(
                child: Column(
                  children: [
                    Text(
                      controller.userProfile?.name ?? 'Loading...',
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: darkTeal,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Psychotherapist',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.teal[600],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),

              // Specialization & Location
              FadeInUp(
                delay: Duration(milliseconds: 100),
                child: Text(
                  '${controller.userProfile?.specialization ?? ''} • ${controller.userProfile?.location ?? ''}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Stats Row
              FadeInUp(
                delay: Duration(milliseconds: 200),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.teal.withOpacity(0.05),
                        blurRadius: 30,
                        offset: Offset(0, 10),
                      ),
                    ],
                    border: Border.all(color: lightTeal, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        value: '${controller.userProfile?.patients ?? 0}',
                        label: 'Patients',
                        icon: Iconsax.people,
                      ),
                      _buildStatItem(
                        value: '${controller.userProfile?.experience ?? '5+'} yrs',
                        label: 'Experience',
                        icon: Iconsax.calendar_tick,
                      ),
                      _buildStatItem(
                        value: '98%',
                        label: 'Success Rate',
                        icon: Iconsax.chart_success,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Action Buttons
              FadeInUp(
                delay: Duration(milliseconds: 300),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: controller.toggleFollow,
                          icon: Icon(
                            controller.userProfile?.isFollowing == true
                                ? Iconsax.tick_circle
                                : Iconsax.add,
                            size: 20,
                          ),
                          label: Text(
                            controller.userProfile?.isFollowing == true
                                ? 'Following'
                                : 'Follow',
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            controller.userProfile?.isFollowing == true
                                ? lightTeal
                                : primaryTeal,
                            foregroundColor:
                            controller.userProfile?.isFollowing == true
                                ? darkTeal
                                : Colors.white,
                            padding: EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: lightTeal, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.teal.withOpacity(0.05),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            Iconsax.message,
                            color: primaryTeal,
                            size: 24,
                          ),
                          onPressed: () {
                            Get.toNamed('/chat', arguments: {
                              'user': controller.userProfile,
                            });
                          },
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
    );
  }

  Widget _buildStatItem({required String value, required String label, required IconData icon}) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: primaryTeal,
            ),
            SizedBox(width: 4),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkTeal,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.2), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: color),
            SizedBox(width: 8),
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreOptions() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),
            _buildActionTile(
              Iconsax.share,
              'Share Profile',
              primaryTeal,
            ),
            _buildActionTile(
              Iconsax.export,
              'Export Schedule',
              Colors.orange,
            ),
            _buildActionTile(
              Iconsax.info_circle,
              'View Availability',
              Colors.green,
            ),
            _buildActionTile(
              Iconsax.security,
              'Verify Credentials',
              secondaryPurple,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(IconData icon, String title, Color color) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Icon(Iconsax.arrow_right_3, size: 20),
      onTap: () => Get.back(),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // About Section
          FadeInLeft(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.05),
                    blurRadius: 20,
                  ),
                ],
                border: Border.all(color: lightTeal, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Iconsax.profile_circle, color: primaryTeal),
                      SizedBox(width: 10),
                      Text(
                        'About Me',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: darkTeal,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    controller.userProfile?.bio ?? '',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),

          // Specializations
          FadeInRight(
            child: Text(
              'Specializations',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkTeal,
              ),
            ),
          ),
          SizedBox(height: 12),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildSpecializationChip('Cognitive Behavioral Therapy'),
              _buildSpecializationChip('Anxiety Disorders'),
              _buildSpecializationChip('Trauma Therapy'),
              _buildSpecializationChip('Depression Treatment'),
              _buildSpecializationChip('Family Counseling'),
              _buildSpecializationChip('Stress Management'),
            ],
          ),
          SizedBox(height: 20),

          // Working Hours
          FadeInLeft(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.05),
                    blurRadius: 20,
                  ),
                ],
                border: Border.all(color: lightTeal, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Iconsax.clock, color: primaryTeal),
                      SizedBox(width: 10),
                      Text(
                        'Working Hours',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: darkTeal,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  _buildWorkingHours(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecializationChip(String specialization) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: primaryTeal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryTeal.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Iconsax.tick_circle, size: 14, color: primaryTeal),
          SizedBox(width: 6),
          Text(
            specialization,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: darkTeal,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkingHours() {
    final hours = {
      'Monday - Friday': '9:00 AM - 6:00 PM',
      'Saturday': '10:00 AM - 2:00 PM',
      'Sunday': 'Emergency Only',
    };

    return Column(
      children: hours.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  entry.key,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: entry.key == 'Sunday'
                      ? Colors.orange.withOpacity(0.1)
                      : primaryTeal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  entry.value,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: entry.key == 'Sunday'
                        ? Colors.orange[800]
                        : primaryTeal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPostsTab() {
    final posts = DummyData.getPostsForUser(glbv.selectedUserId);

    return ListView.builder(
      padding: EdgeInsets.all(20),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return FadeInUp(
          delay: Duration(milliseconds: index * 100),
          child: Container(
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withOpacity(0.05),
                  blurRadius: 20,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Post Header
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                      'https://i.pravatar.cc/300?u=${post.userId}',
                    ),
                  ),
                  title: Text(
                    post.userName,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    'Therapist • ${post.createdAt}',
                    style: TextStyle(fontSize: 12),
                  ),
                  trailing: Icon(Iconsax.more, size: 20),
                ),

                // Post Content
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.contentText,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                      SizedBox(height: 12),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                // Post Actions
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          post.isLiked ? Iconsax.heart5 : Iconsax.heart,
                          color: post.isLiked ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {},
                      ),
                      Text('${post.likes}'),
                      SizedBox(width: 20),
                      Icon(Iconsax.message, color: Colors.grey),
                      SizedBox(width: 4),
                      Text('${post.comments}'),
                      Spacer(),
                      Icon(Iconsax.share, color: Colors.grey),
                      SizedBox(width: 4),
                      Text('${post.shares}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _buildJourneyTab() {
    return Column(
      children: [
        // Journey Tab Bar
        SizedBox(height: 20,),
        Container(
          height: 45,
          color: Colors.white,
          child: TabBar(
            controller: controller.journeyTabController,
            onTap: controller.changeJourneyTab,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                colors: [primaryTeal, accentTeal],
              ),
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(
                icon: Icon(Iconsax.calendar_1, size: 20),
                text: 'Timeline',
              ),
              Tab(
                icon: Icon(Iconsax.award, size: 20),
                text: 'Certificates',
              ),
            ],
          ),
        ),

        // Journey Tab Content
        Expanded(
          child: TabBarView(
            controller: controller.journeyTabController,
            children: [
              _buildTimelineContent(),
              _buildCertificatesContent(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Professional Journey',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: darkTeal,
                ),
              ),
              GestureDetector(
                onTap: _downloadTimeline,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: primaryTeal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: primaryTeal.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Iconsax.document_download, size: 16, color: primaryTeal),
                      SizedBox(width: 6),
                      Text(
                        'Export CV',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: primaryTeal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          _buildTherapistTimeline(controller.timelineEvents),
        ],
      ),
    );
  }

  Widget _buildCertificatesContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  'Certifications & Credentials',
                  softWrap: true,
                  maxLines: 3,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: darkTeal,
                  ),
                ),
              ),
              GestureDetector(
                onTap: _exportAllCertificates,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: primaryTeal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: primaryTeal.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Iconsax.archive, size: 16, color: primaryTeal),
                      SizedBox(width: 6),
                      Text(
                        'Export All',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: primaryTeal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '${controller.certificates.length} verified certificates',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 20),

          // Grid View for Certificates
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              mainAxisExtent: 250,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.85,
            ),
            itemCount: controller.certificates.length,
            itemBuilder: (context, index) {
              final certificate = controller.certificates[index];
              return _buildCertificateGridCard(certificate);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCertificateGridCard(Certificate certificate) {
    return GestureDetector(
      onTap: () => controller.viewCertificateDetails(certificate),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.teal.withOpacity(0.05),
              blurRadius: 20,
              offset: Offset(0, 5),
            ),
          ],
          border: Border.all(
            color: certificate.color.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Certificate Header
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    certificate.color.withOpacity(0.8),
                    certificate.color.withOpacity(0.4),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 15,
                    right: 15,
                    child: Icon(
                      certificate.icon,
                      color: Colors.white.withOpacity(0.8),
                      size: 30,
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    left: 15,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'CERTIFIED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Certificate Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      certificate.title,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: darkTeal,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6),
                    Text(
                      certificate.issuingOrganization,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: certificate.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _formatDateShort(certificate.issueDate),
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: certificate.color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Iconsax.arrow_right_3,
                            size: 14,
                            color: primaryTeal,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTherapistTimeline(List<dynamic> events) {
    return Container(
      child: Stack(
        children: [
          // Vertical Line with Gradient
          Positioned(
            left: 25,
            top: 0,
            bottom: 0,
            child: Container(
              width: 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    primaryTeal.withOpacity(0.8),
                    accentTeal.withOpacity(0.8),
                    Colors.teal.shade200.withOpacity(0.8),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
          ),

          // Timeline Items
          Column(
            children: events.reversed.toList().asMap().entries.map((entry) {
              final index = entry.key;
              final event = entry.value;

              return Container(
                margin: EdgeInsets.only(bottom: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline Indicator
                    Container(
                      width: 50,
                      child: Column(
                        children: [
                          // Indicator Dot
                          Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                              gradient: _getTherapistEventGradient(event),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: _getTherapistEventColor(event)
                                      .withOpacity(0.4),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                _getTherapistEventIcon(event),
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 15),

                    // Event Card
                    Expanded(
                      child: _buildTherapistTimelineEventCard(event),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTherapistTimelineEventCard(dynamic event) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: _getTherapistEventColor(event).withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: _getTherapistEventGradient(event),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      _getTherapistEventIcon(event),
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _getEventTitle(event),
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: darkTeal,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              _getEventDescription(event),
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Iconsax.calendar,
                  size: 14,
                  color: Colors.grey[500],
                ),
                SizedBox(width: 4),
                Text(
                  _formatDate(_getEventDate(event)),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _downloadTimeline() {
    Get.dialog(
      AlertDialog(
        title: Text('Export Professional Journey',
            style: TextStyle(color: darkTeal, fontWeight: FontWeight.bold)),
        content: Text('Would you like to download the timeline as PDF?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel',
                style: TextStyle(color: Colors.grey[600])),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF004D4D), Color(0xFF002D2D)],
                stops: [0.0, 0.7],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ElevatedButton(
              onPressed: () {
                Get.back();
                Get.snackbar(
                  'Download Started',
                  'Your CV will be downloaded shortly',
                  backgroundColor: primaryTeal,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Download PDF',style: GoogleFonts.poppins(color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }

  void _exportAllCertificates() {
    Get.dialog(
      AlertDialog(
        title: Text('Export All Certificates',
            style: TextStyle(color: darkTeal, fontWeight: FontWeight.bold)),
        content: Text('Export all ${controller.certificates.length} certificates as a PDF portfolio?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel',
                style: TextStyle(color: Colors.grey[600])),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF004D4D), Color(0xFF002D2D)],
                stops: [0.0, 0.7],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ElevatedButton(
              onPressed: () {
                Get.back();
                Get.snackbar(
                  'Export Started',
                  'All certificates will be downloaded as PDF portfolio',
                  backgroundColor: primaryTeal,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              child: Text('Export Portfolio'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods for timeline
  Color _getTherapistEventColor(dynamic event) {
    if (event is TimelineEvent) return event.color;
    if (event is Milestone) return event.color;
    return primaryTeal;
  }

  Gradient _getTherapistEventGradient(dynamic event) {
    final Color baseColor = _getTherapistEventColor(event);
    return LinearGradient(
      colors: [baseColor, Color.lerp(baseColor, Colors.white, 0.2)!],
    );
  }

  IconData _getTherapistEventIcon(dynamic event) {
    if (event is TimelineEvent) return event.icon;
    if (event is Milestone) return event.icon;
    return Icons.work;
  }

  String _getEventTitle(dynamic event) {
    if (event is TimelineEvent) return event.title;
    if (event is Milestone) return event.title;
    return '';
  }

  String _getEventDescription(dynamic event) {
    if (event is TimelineEvent) return event.description;
    if (event is Milestone) return event.description;
    return '';
  }

  DateTime _getEventDate(dynamic event) {
    if (event is TimelineEvent) return event.date;
    if (event is Milestone) return event.date;
    return DateTime.now();
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _formatDateShort(DateTime date) {
    return '${date.day}/${date.month}/${date.year.toString().substring(2)}';
  }
}

// Main Tab Bar Delegate
class _MainTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  final Function(int) onTabChanged;

  _MainTabBarDelegate({required this.tabController, required this.onTabChanged});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: tabController,
        onTap: onTabChanged,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [
              TherapistProfileView.primaryTeal,
              TherapistProfileView.accentTeal
            ],
          ),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        tabs: [
          Tab(
            icon: Icon(Iconsax.profile_circle, size: 20),
            text: 'Overview',
          ),
          Tab(
            icon: Icon(Iconsax.document, size: 20),
            text: 'Posts',
          ),
          Tab(
            icon: Icon(Iconsax.calendar, size: 20),
            text: 'Journey',
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}