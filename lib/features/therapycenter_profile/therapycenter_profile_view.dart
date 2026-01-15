import 'dart:ui' as ui;

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:myapp/features/therapycenter_profile/therapycenter_profile_controller.dart';
import 'package:myapp/models/user.dart';
import '../../core/globals/dummy_data.dart';
import '../../core/globals/global_variables.dart' as glbv;

class TherapycenterProfileView extends GetView<TherapycenterProfileController> {
  // Color definitions for Therapy Center
  static const Color primaryTeal = Color(0xFF008080);
  static const Color accentTeal = Color(0xFF4DB6AC);
  static const Color lightTeal = Color(0xFFE0F2F1);
  static const Color darkTeal = Color(0xFF004D40);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(
        () => (controller.isLoading.value)
            ? LoadingAnimationWidget.hexagonDots(color: primaryTeal, size: 32)
            : CustomScrollView(
                slivers: <Widget>[
                  // App Bar Sliver
                  SliverAppBar(
                    expandedHeight: 460,
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
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildActionButton(
                                icon: Iconsax.location,
                                text: 'Get Directions',
                                color: primaryTeal,
                                onTap: _getDirections,
                              ),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: _buildActionButton(
                                icon: Iconsax.calendar,
                                text: 'Talk to AI',
                                color: Colors.teal.shade900,
                                onTap: controller.bookAppointment,
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
                      height: 600,
                      child: TabBarView(
                        controller: controller.tabController,
                        children: [
                          _buildOverviewTab(),
                          _buildPostsTab(),
                          _buildCertificationsTab(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
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
              // Center Logo/Image
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
                            Iconsax.building,
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
                            Iconsax.building,
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

              // Center Name & Verification
              FadeInUp(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            controller.userProfile?.name ?? 'Loading...',
                            textAlign:TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: darkTeal,
                            ),
                          ),
                        ),

                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Mental Health & Wellness Center',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.blue[600],
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
                        color: Colors.blue.withOpacity(0.05),
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
                        value: '${controller.userProfile?.patients ?? 0}+',
                        label: 'Patients Treated',
                        icon: Iconsax.people,
                      ),
                      _buildStatItem(
                        value: '${controller.userProfile?.therapists ?? 0}',
                        label: 'Specialists',
                        icon: Iconsax.health,
                      ),
                      _buildStatItem(
                        value: '4.9',
                        label: 'Rating',
                        icon: Iconsax.star,
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
                                : 'Follow Center',
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
                              color: Colors.blue.withOpacity(0.05),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            Iconsax.call,
                            color: primaryTeal,
                            size: 24,
                          ),
                          onPressed: () {
                            // Implement call functionality
                            controller.contactCenter();
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

  Widget _buildStatItem({
    required String value,
    required String label,
    required IconData icon,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: primaryTeal),
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
          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600]),
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
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
            _buildActionTile(Iconsax.share, 'Share Center', primaryTeal),
            _buildActionTile(
              Iconsax.info_circle,
              'Center Information',
              Colors.blue,
            ),
            _buildActionTile(Iconsax.map, 'View Facilities', Colors.green),
            _buildActionTile(
              Iconsax.security,
              'Safety Protocols',
              Colors.orange,
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
        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      trailing: Icon(Iconsax.arrow_right_3, size: 20),
      onTap: () => Get.back(),
    );
  }

  void _getDirections() {
    Get.snackbar(
      'Directions',
      'Opening Maps for ${controller.userProfile?.name}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: primaryTeal,
      colorText: Colors.white,
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // About Center Section
          FadeInLeft(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.05),
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
                      Icon(Iconsax.building_4, color: primaryTeal),
                      SizedBox(width: 10),
                      Text(
                        'About Our Center',
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

          // Services Offered
          FadeInRight(
            child: Text(
              'Services Offered',
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
            children: controller.services.map((service) {
              return _buildServiceChip(service);
            }).toList(),
          ),
          SizedBox(height: 20),



          // Contact Information
          FadeInRight(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.05),
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
                      Icon(Iconsax.location, color: primaryTeal),
                      SizedBox(width: 10),
                      Text(
                        'Contact Information',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: darkTeal,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  _buildContactRow(Iconsax.call, 'Phone:', '+1 (555) 123-4567'),
                  _buildContactRow(Iconsax.sms, 'Email:', 'info@center.com'),
                  _buildContactRow(
                    Iconsax.global,
                    'Website:',
                    'www.center.com',
                  ),
                  _buildContactRow(Iconsax.clock, 'Hours:', 'Mon-Fri: 8AM-8PM'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceChip(String service) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: primaryTeal.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryTeal.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Iconsax.tick_circle, size: 14, color: primaryTeal),
          SizedBox(width: 8),
          Text(
            service,
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

  Widget _buildStaffMemberCard(dynamic member) {
    return Container(
      width: 140,
      margin: EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.05),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
        border: Border.all(color: lightTeal, width: 1),
      ),
      child: Column(
        children: [
          Container(
            height: 90,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: CachedNetworkImage(
                imageUrl: member.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: lightTeal,
                  child: Center(child: Icon(Iconsax.user, color: primaryTeal)),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name.split(' ')[0],
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: darkTeal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2),
                Text(
                  member.role,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.blue[600],
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  member.experience,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: primaryTeal),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsTab() {
    return ListView.builder(
      padding: EdgeInsets.all(20),
      itemCount: controller.posts.length,
      itemBuilder: (context, index) {
        final post = controller.posts[index];
        return FadeInUp(
          delay: Duration(milliseconds: index * 100),
          child: Container(
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.05),
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
                    backgroundColor: lightTeal,
                    child: Icon(Iconsax.building, color: primaryTeal),
                  ),
                  title: Text(
                    post.userName,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    'Therapy Center • ${post.createdAt}',
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
                        style: GoogleFonts.inter(fontSize: 14, height: 1.6),
                      ),
                      SizedBox(height: 12),

                      // Display images if available
                      if (post.images != null && post.images!.isNotEmpty)
                        _buildPostImages(post.images!),
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

  Widget _buildPostImages(List<String> images) {
    if (images.length == 1) {
      // Single image
      return Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: NetworkImage(images.first),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      // Multiple images grid
      return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1,
        ),
        itemCount: images.length > 4 ? 4 : images.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(images[index]),
                fit: BoxFit.cover,
              ),
            ),
            child: images.length > 4 && index == 3
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        '+${images.length - 3}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                : null,
          );
        },
      );
    }
  }

  Widget _buildCertificationsTab() {
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
                  'Accreditations & Certifications',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: darkTeal,
                  ),
                ),
              ),
              GestureDetector(
                onTap: _exportAllCertifications,
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
            '${controller.certificates.length} verified accreditations',
            style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height: 20),

          // List View for Certifications
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: controller.certificates.length,
            itemBuilder: (context, index) {
              final certificate = controller.certificates[index];
              return _buildCertificationListItem(certificate);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCertificationListItem(TherapyCenterCertificate certificate) {
    return GestureDetector(
      onTap: () => controller.viewCertificateDetails(certificate),
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.05),
              blurRadius: 20,
              offset: Offset(0, 5),
            ),
          ],
          border: Border.all(
            color: certificate.color.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Certificate Icon
            Container(
              width: 70,
              height: 70,
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
                  bottomLeft: Radius.circular(15),
                ),
              ),
              child: Center(
                child: Icon(certificate.icon, color: Colors.white, size: 30),
              ),
            ),

            // Certificate Details
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: certificate.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            certificate.type.toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: certificate.color,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Iconsax.arrow_right_3,
                          size: 16,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Text(
                      certificate.title,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: darkTeal,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      certificate.issuingOrganization,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
                          _formatDate(certificate.issueDate),
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                        Spacer(),
                        if (certificate.expiryDate != null)
                          Row(
                            children: [
                              Icon(
                                Iconsax.clock,
                                size: 14,
                                color: Colors.orange[400],
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Expires: ${_formatDateShort(certificate.expiryDate!)}',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: Colors.orange[600],
                                ),
                              ),
                            ],
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

  void _exportAllCertifications() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Export All Certifications',
          style: TextStyle(color: darkTeal, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Export all ${controller.certificates.length} certifications as a PDF portfolio?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [darkTeal, primaryTeal],
                stops: [0.0, 0.7],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ElevatedButton(
              onPressed: () {
                Get.back();
                Get.snackbar(
                  'Export Started',
                  'All certifications will be downloaded as PDF portfolio',
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

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  String _formatDateShort(DateTime date) {
    return '${date.day}/${date.month}/${date.year.toString().substring(2)}';
  }
}

// Tab Bar Delegate
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  final Function(int) onTabChanged;

  _TabBarDelegate({required this.tabController, required this.onTabChanged});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: tabController,
        onTap: onTabChanged,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [Color(0xFF008080), Color(0xFF4DB6AC)],
          ),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        tabs: [
          Tab(icon: Icon(Iconsax.profile_circle, size: 20), text: 'Overview'),
          Tab(icon: Icon(Iconsax.gallery, size: 20), text: 'Posts'),
          Tab(icon: Icon(Iconsax.award, size: 20), text: 'Certifications'),
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
