import 'dart:ui' as ui;

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:myapp/features/profile_views/patient_profile_controller.dart';
import 'package:myapp/models/user.dart';

import '../../core/globals/dummy_data.dart';
import '../../core/globals/global_variables.dart' as glbv;


class PatientProfileView extends GetView<PatientProfileController> {


  // Color definitions
  static const Color primaryTeal = Color(0xFF008080);
  static const Color accentTeal = Color(0xFF4DB6AC);
  static const Color lightTeal = Color(0xFFE0F2F1);
  static const Color darkTeal = Color(0xFF004D40);
  static const Color gradientStart = Color(0xFF008080);
  static const Color gradientEnd = Color(0xFF004D40);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(()=>(controller.isLoading.value)?LoadingAnimationWidget.hexagonDots(color: Colors.teal.shade900, size: 32):CustomScrollView(
        slivers: <Widget>[
          // App Bar Sliver
          SliverAppBar(
            expandedHeight: 400,
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
                onPressed: () {
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
                            'Export Data',
                            Colors.orange,
                          ),
                          _buildActionTile(
                            Iconsax.info_circle,
                            'Report Profile',
                            Colors.red,
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          // Connection & AI Section
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
                        icon: Iconsax.message,
                        text: 'Talk to AI',
                        color: accentTeal,
                        onTap: controller.talkToAI,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Tab Bar
          SliverPersistentHeader(
            delegate: _TabBarDelegate(
              tabController: controller.tabController,
              onTabChanged: controller.changeTab,
            ),
            pinned: true,
          ),

          // Tab Content
          SliverToBoxAdapter(

            child: SizedBox(
              height: 500,
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  _buildOverviewTab(),
                  // _buildPostsTab(),
                  _buildTimelineTab(),
                ],
              ),
            ),
          ),
        ],
      ),
      ));
  }

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
              // Profile Image
              ZoomIn(
                child: Container(
                  width: 120,
                  height: 120,
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
                    borderRadius: BorderRadius.circular(60),
                    child: CachedNetworkImage(
                      imageUrl: 'https://i.pravatar.cc/300?u=${controller.userProfile?.id}',
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
              SizedBox(height: 16),

              // Name & Verification
              FadeInUp(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      controller.userProfile?.name ?? 'Loading...',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: darkTeal,
                      ),
                    ),
                    SizedBox(width: 8),
                    if (controller.userProfile?.isVerified == true)
                      Icon(
                        Iconsax.verify,
                        color: Colors.blue,
                        size: 20,
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
                        value: '${controller.userProfile?.followers ?? 0}',
                        label: 'Followers',
                        icon: Iconsax.people,
                      ),
                      // _buildStatItem(
                      //   value: '${controller.userProfile?.posts ?? 0}',
                      //   label: 'Posts',
                      //   icon: Iconsax.document,
                      // ),
                      _buildStatItem(
                        value: '85%',
                        label: 'Progress',
                        icon: Iconsax.chart,
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
                            backgroundColor: controller.userProfile?.isFollowing == true
                                ? lightTeal
                                : primaryTeal,
                            foregroundColor: controller.userProfile?.isFollowing == true
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
          // Bio Section
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
                        'About',
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

          // Recent Activity
          FadeInRight(
            child: Text(
              'Recent Activity',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkTeal,
              ),
            ),
          ),
          SizedBox(height: 12),

          // Activity Cards
          ...List.generate(3, (index) {
            return FadeInRight(
              delay: Duration(milliseconds: index * 100),
              child: Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: lightTeal, width: 1),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: primaryTeal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        [Iconsax.like, Iconsax.message, Iconsax.share][index],
                        color: primaryTeal,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ['Liked a post', 'Commented', 'Shared progress'][index],
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: darkTeal,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '2 hours ago',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
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
                    '${post.userRole} • ${post.createdAt}',
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

                      // Tags
                      // Wrap(
                      //   spacing: 8,
                      //   children: post.tags!.map((tag) {
                      //     return Container(
                      //       padding: EdgeInsets.symmetric(
                      //         horizontal: 12,
                      //         vertical: 6,
                      //       ),
                      //       decoration: BoxDecoration(
                      //         color: primaryTeal.withOpacity(0.1),
                      //         borderRadius: BorderRadius.circular(10),
                      //       ),
                      //       child: Text(
                      //         '#$tag',
                      //         style: GoogleFonts.inter(
                      //           fontSize: 12,
                      //           color: primaryTeal,
                      //         ),
                      //       ),
                      //     );
                      //   }).toList(),
                      // ),
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

  Widget _buildTimelineTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          // Timeline Header
          Row(
            children: [
              Text(
                'Health Journey',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: darkTeal,
                ),
              ),
              Spacer(),
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
                        'Export',
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

          // Your existing timeline widget
          _buildVerticalTimeline(controller.timelineEvents),
        ],
      ),
    );
  }

  // Your existing timeline methods (keep them as is)
  Widget _buildVerticalTimeline(List<dynamic> events) {
    // ... Your existing timeline code from the question ...
    // Keep all your existing timeline building methods
    return Container(
      // Your existing timeline implementation
      child: Stack(
        children: [
          // Vertical Line with Gradient
          Positioned(
            left: 30,
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
            children: events.reversed.toList()
                .asMap()
                .entries
                .map((entry) {
              final index = entry.key;
              final event = entry.value;

              return Container(
                margin: EdgeInsets.only(bottom: 32),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline Indicator
                    Container(
                      width: 60,
                      child: Column(
                        children: [
                          // Indicator Dot
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              gradient: _getEventGradient(event),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: _getEventColor(event).withOpacity(0.4),
                                  blurRadius: 12,
                                  spreadRadius: 3,
                                ),
                              ],
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                _getEventIcon(event),
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          // Connector Line
                          if (index < events.length - 1)
                            Container(
                              width: 2,
                              height: 70,
                              margin: EdgeInsets.only(top: 4),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    _getEventColor(event).withOpacity(0.3),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),

                    // Event Card
                    Expanded(
                      child: _buildTimelineEventCard(event),
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

  Widget _buildTimelineEventCard(dynamic event) {
    final bool isMilestone = event is Milestone;

    return Transform.translate(
        offset: Offset(0, -8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.teal.withOpacity(0.05),
                blurRadius: 30,
                offset: Offset(0, 15),
                spreadRadius: -5,
              ),
            ],
            border: Border.all(
              color: _getEventColor(event).withOpacity(0.15),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.9),
                      Colors.white.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with Icon
                      Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: _getEventGradient(event),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: _getEventColor(event).withOpacity(0.2),
                                  blurRadius: 15,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                _getEventIcon(event),
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _getEventTitle(event),
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: darkTeal,
                                          letterSpacing: 0.3,
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
                      SizedBox(height: 4),
                      if (isMilestone)
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xFFFFB74D),
                                    Color(0xFFFF9800),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.star,
                                      size: 12, color: Colors.white),
                                  SizedBox(width: 4),
                                  Text(
                                    'MILESTONE',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      SizedBox(height: 4),
                      Text(
                        _formatDate(_getEventDate(event)),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 20),

                      // Description
                      Text(
                        _getEventDescription(event),
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey[700],
                          height: 1.6,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 16),

                      // Footer
                      Container(
                        padding: EdgeInsets.only(top: 16),
                        decoration: BoxDecoration(
                            border: Border(top: BorderSide(
                              color: Colors.teal.withOpacity(0.1),
                              width: 1,
                            ),)
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getEventColor(event).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _getEventColor(event).withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                _getEventType(event).toUpperCase(),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _getEventColor(event),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.grey[500],
                            ),
                            SizedBox(width: 6),
                            Text(
                              '${_getEventDate(event).hour}:${_getEventDate(event).minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
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
          ),
        ));
    }

  // Keep all your existing helper methods
  Color _getEventColor(dynamic event) {
    if (event is TimelineEvent) return event.color;
    if (event is Milestone) return event.color;
    return primaryTeal;
  }

  Gradient _getEventGradient(dynamic event) {
    final Color baseColor = _getEventColor(event);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF004D4D), Color(0xFF002D2D)],
      stops: [0.0, 0.7],
    );
  }

  IconData _getEventIcon(dynamic event) {
    if (event is TimelineEvent) return event.icon;
    if (event is Milestone) return event.icon;
    return Icons.event;
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

  String _getEventType(dynamic event) {
    if (event is TimelineEvent) return event.type;
    if (event is Milestone) return 'milestone';
    return 'event';
  }

  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _downloadTimeline() {
    Get.dialog(
      AlertDialog(
        title: Text('Download Timeline',
            style: TextStyle(color: darkTeal, fontWeight: FontWeight.bold)),
        content: Text('Would you like to download the timeline as PDF or PNG?'),
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
                  'Your timeline will be downloaded shortly',
                  backgroundColor: primaryTeal,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              child: Text('Download PDF'),
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
}

// Tab Bar Delegate
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  final Function(int) onTabChanged;

  _TabBarDelegate({required this.tabController, required this.onTabChanged});

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
            colors: [PatientProfileView.primaryTeal, PatientProfileView.accentTeal],
          ),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        tabs: [
          Tab(
            icon: Icon(Iconsax.profile_circle, size: 20),
            text: 'Overview',
          ),
          // Tab(
          //   icon: Icon(Iconsax.document, size: 20),
          //   text: 'Posts',
          // ),
          Tab(
            icon: Icon(Iconsax.calendar, size: 20),
            text: 'Timeline',
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