import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myapp/features/community_page/community_page_controller.dart';
import 'package:myapp/navigation/routes_constant.dart';
import '../../core/globals/dummy_data.dart';
import '../../core/globals/global_variables.dart' as glbv;
import '../../core/globals/profile_generator.dart';
import '../../models/user.dart';

class CommunityPageView extends GetView<CommunityPageController> {
  // Modern color palette
  final Color _primaryColor = const Color(0xFF0A7C8F);
  final Color _secondaryColor = const Color(0xFF5EB8B3);
  final Color _accentColor = const Color(0xFFF5A623);
  final Color _backgroundColor = const Color(0xFFF9FAFC);
  final Color _cardColor = Colors.white;
  final Color _textPrimary = const Color(0xFF1A2B3C);
  final Color _textSecondary = const Color(0xFF5E6D7E);
  final Color _textTertiary = const Color(0xFF94A3B8);
  final Color _successColor = const Color(0xFF10B981);
  final Color _warningColor = const Color(0xFFF59E0B);
  final Color _errorColor = const Color(0xFFEF4444);

  // Elegant shadows
  final List<BoxShadow> _cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 24.0,
      spreadRadius: -2,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.03),
      blurRadius: 6.0,
      spreadRadius: -4,
      offset: const Offset(0, 4),
    ),
  ];

  final List<BoxShadow> _floatingShadow = [
    BoxShadow(
      color: Colors.teal.withOpacity(0.15),
      blurRadius: 20.0,
      spreadRadius: -5,
      offset: const Offset(0, 10),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 10.0,
      offset: const Offset(0, 5),
    ),
  ];

  final List<BoxShadow> _softShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.03),
      blurRadius: 15.0,
      spreadRadius: -8,
      offset: const Offset(0, 4),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        slivers: [
          // Modern App Bar with Gradient
          _buildModernAppBar(),

          // Search Results Section with subtle animation
          SliverPadding(
            padding: const EdgeInsets.only(top: 8.0),
            sliver: _buildSearchResults(),
          ),

          // Add a subtle decorative element at the bottom
          _buildBottomDecoration(),
        ],
      ),
      // Add a floating action button for quick actions
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  SliverAppBar _buildModernAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      floating: true,
      snap: false,
      leading: Container(
        margin: const EdgeInsets.all(8),


        child: IconButton(
          icon: Icon(
            Iconsax.arrow_left_2,
            color: Colors.white,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      expandedHeight: 180.0,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF004D4D), Color(0xFF002D2D)],
              stops: [0.0, 0.7],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16.0),
                  // Welcome text with fade-in animation
                  AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Community Hub',
                          style: TextStyle(
                            fontSize: 32.0,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          'Connect with professionals and peers',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.9),
                            letterSpacing: 0.2,
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
        title: Container(),
        centerTitle: false,
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: Transform.translate(
          offset: const Offset(0, 20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: _buildModernSearchBar(),
          ),
        ),
      ),
    );
  }

  Widget _buildModernSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: _floatingShadow,
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: TextField(
          controller: controller.searchController,
          onChanged: (value) => controller.searchUsers(value),
          decoration: InputDecoration(
            hintText: 'Search name, specialization, or location...',
            hintStyle: TextStyle(
              color: _textTertiary,
              fontWeight: FontWeight.w400,
            ),
            border: InputBorder.none,
            prefixIcon: Container(
              margin: const EdgeInsets.only(left: 16, right: 12),
              child: Icon(
                Icons.search_rounded,
                color: _primaryColor,
                size: 24.0,
              ),
            ),
            suffixIcon: controller.searchQuery.isNotEmpty
                ? IconButton(
                    icon: Container(
                      decoration: BoxDecoration(
                        color: _textTertiary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.close_rounded,
                        color: _textTertiary,
                        size: 20.0,
                      ),
                    ),
                    onPressed: () {
                      controller.searchController.clear();
                      controller.searchUsers('');
                    },
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 16.0,
            ),
          ),
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: _textPrimary,
          ),
          cursorColor: _primaryColor,
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Obx(() {
      if (controller.searchQuery.isEmpty) {
        return _buildCategories();
      } else {
        return _buildSearchResultsList();
      }
    });
  }

  Widget _buildCategories() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          _buildCategorySection(
            title: '👨‍⚕️ Top Therapists',
            subtitle: 'Verified mental health professionals',
            users: DummyData.getTherapists().take(4).toList(),
            seeAllRoute: '/therapists',
            gradientColors: [
              const   Color(0xFF2DD4BF).withOpacity(0.9), // Light teal for therapists
              const  Color(0xFF0D9488).withOpacity(0.9),
            ],
          ),
          const SizedBox(height: 30.0),
          _buildCategorySection(
            title: '🏥 Featured Centers',
            subtitle: 'Trusted therapy centers near you',
            users: DummyData.getTherapyCenters().take(4).toList(),
            seeAllRoute: '/centers',
            gradientColors: [
              const  Color(0xFF0D9488).withOpacity(0.9), // Medium teal for centers
              const   Color(0xFF115E59).withOpacity(0.9),
            ],
          ),
          if (glbv.role == "patient") ...[
            const SizedBox(height: 30.0),
            _buildCategorySection(
              title: '🤝 Community Peers',
              subtitle: 'Connect with fellow patients',
              users: DummyData.getPatients().take(4).toList(),
              seeAllRoute: '/patients',
              gradientColors: [
               const Color(0xFF115E59).withOpacity(0.9), // Dark teal for patients
                const Color(0xFF134E4A).withOpacity(0.9),
              ],
            ),
          ],
        ]),
      ),
    );
  }

  Widget _buildCategorySection({
    required String title,
    required String subtitle,
    required List<UserProfile> users,
    required String seeAllRoute,
    required List<Color> gradientColors,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: _softShadow,
          ),
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              _buildSeeAllButton(seeAllRoute, Colors.white),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        // Cards grid
        SizedBox(
          height: 230.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: users.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  right: index == users.length - 1 ? 0 : 16.0,
                ),
                child: _buildModernCategoryCard(users[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildModernCategoryCard(UserProfile user) {
    return Container(
      width: 160.0,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: _cardShadow,
            border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1.0),
          ),
          child: InkWell(
            onTap: () => _showUserProfile(user),
            borderRadius: BorderRadius.circular(20.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar with gradient border
                  Center(
                    child: Container(
                      width: 70.0,
                      height: 70.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            _getRoleColor(user.role),
                            _getRoleColor(user.role).withOpacity(0.7),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _getRoleColor(user.role).withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: // Replace the entire avatar section in _buildModernCategoryCard
                      Center(
                        child: Container(
                          width: 70.0,
                          height: 70.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                _getRoleColor(user.role),
                                _getRoleColor(user.role).withOpacity(0.7),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _getRoleColor(user.role).withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Container(
                              width: 64.0,
                              height: 64.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: _cardColor, width: 3.0),
                              ),
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: ProfileImageHelper.getRandomImage(user.name, user.role),
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: _getRoleColor(user.role).withOpacity(0.1),
                                    child: Center(
                                      child: Icon(
                                        _getRoleIcon(user.role),
                                        size: 24.0,
                                        color: _getRoleColor(user.role),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: _getRoleColor(user.role).withOpacity(0.1),
                                    child: Center(
                                      child: Icon(
                                        _getRoleIcon(user.role),
                                        size: 24.0,
                                        color: _getRoleColor(user.role),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // Name with verification
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          (user.role == "therapist")
                              ? user.name.split(' ')[0] +
                                    user.name.split(' ')[1]
                              : user.name.split(' ')[0],
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            color: _textPrimary,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      if (user.isVerified)
                        Icon(
                          Icons.verified_rounded,
                          color: _successColor,
                          size: 16.0,
                        ),
                    ],
                  ),
                  const SizedBox(height: 6.0),
                  // Role/Specialization
                  Text(
                    user.specialization ?? user.role.replaceAll('_', ' '),
                    style: TextStyle(
                      fontSize: 13.0,
                      color: _textSecondary,
                      fontWeight: FontWeight.w400,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 2,
                  ),
                  const Spacer(),
                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14.0,
                        color: _textTertiary,
                      ),
                      const SizedBox(width: 6.0),
                      Expanded(
                        child: Text(
                          user.location ?? 'Location',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: _textTertiary,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResultsList() {
    return Obx(() {
      final filteredUsers = controller.filteredUsers;

      if (filteredUsers.isEmpty) {
        return SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120.0,
                  height: 120.0,
                  decoration: BoxDecoration(
                    color: _backgroundColor,
                    shape: BoxShape.circle,
                    boxShadow: _softShadow,
                  ),
                  child: Icon(
                    Icons.search_off_rounded,
                    size: 50.0,
                    color: _textTertiary.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 24.0),
                Text(
                  'No Results Found',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700,
                    color: _textPrimary,
                  ),
                ),
                const SizedBox(height: 12.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(
                    'Try searching with different keywords or browse our categories',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16.0, color: _textSecondary),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final user = filteredUsers[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _buildModernUserCard(user),
            );
          }, childCount: filteredUsers.length),
        ),
      );
    });
  }

  Widget _buildModernUserCard(UserProfile user) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showUserProfile(user),
        borderRadius: BorderRadius.circular(24.0),
        child: Container(
          decoration: BoxDecoration(
            color: _cardColor,
            borderRadius: BorderRadius.circular(24.0),
            boxShadow: _cardShadow,
            border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar with status indicator
                const SizedBox(width: 20.0),
                // User info
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: // Replace the Stack widget in _buildModernUserCard
                      Stack(
                        children: [
                          Container(
                            width: 70.0,
                            height: 70.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  _getRoleColor(user.role),
                                  _getRoleColor(user.role).withOpacity(0.8),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _getRoleColor(user.role).withOpacity(0.2),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Container(
                                width: 64.0,
                                height: 64.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: _cardColor, width: 3.0),
                                ),
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: ProfileImageHelper.getRandomImage(user.name, user.role),
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: _getRoleColor(user.role).withOpacity(0.1),
                                      child: Center(
                                        child: Icon(
                                          _getRoleIcon(user.role),
                                          size: 26.0,
                                          color: _getRoleColor(user.role),
                                        ),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                      color: _getRoleColor(user.role).withOpacity(0.1),
                                      child: Center(
                                        child: Icon(
                                          _getRoleIcon(user.role),
                                          size: 26.0,
                                          color: _getRoleColor(user.role),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 20.0,
                              height: 20.0,
                              decoration: BoxDecoration(
                                color: _getRoleColor(user.role),
                                shape: BoxShape.circle,
                                border: Border.all(color: _cardColor, width: 2.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        user.name,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                          color: _textPrimary,
                        ),
                      ),
                    ),
                    _buildModernFollowButton(user),
                  ],
                ),
                const SizedBox(height: 6.0),
                Text(
                  user.specialization ?? user.role.replaceAll('_', ' '),
                  style: TextStyle(
                    fontSize: 14.0,
                    color: _secondaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12.0),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16.0,
                      color: _textTertiary,
                    ),
                    const SizedBox(width: 6.0),
                    Text(
                      user.location ?? 'Unknown Location',
                      style: TextStyle(fontSize: 14.0, color: _textSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                _buildModernUserStats(user),

                // Follow button
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernUserStats(UserProfile user) {
    return Container(
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildModernStatItem(
            Icons.people_outline,
            '${user.followers}',
            'Followers',
          ),
          _buildModernStatItem(
            Icons.article_outlined,
            '${user.posts}',
            'Posts',
          ),
          if (user.patients != null)
            _buildModernStatItem(
              Icons.person_outline,
              '${user.patients}',
              'Patients',
            ),
          if (user.therapists != null)
            _buildModernStatItem(
              Icons.medical_services_outlined,
              '${user.therapists}',
              'Therapists',
            ),
        ],
      ),
    );
  }

  Widget _buildModernStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14.0, color: _primaryColor),
            const SizedBox(width: 4.0),
            Text(
              value,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w700,
                color: _textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2.0),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.0,
            color: _textTertiary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildModernFollowButton(UserProfile user) {
    return Obx(() {
      final isFollowing = controller.followingUsers.contains(user.id);
      return Container(
        width: 110.0,
        height: 40.0,
        decoration: BoxDecoration(
          gradient: isFollowing
              ? LinearGradient(
                  colors: [
                    _textTertiary.withOpacity(0.1),
                    _textTertiary.withOpacity(0.05),
                  ],
                )
              : LinearGradient(
                  colors: [_primaryColor, _secondaryColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(12.0),
          border: isFollowing
              ? Border.all(color: _textTertiary.withOpacity(0.2))
              : null,
          boxShadow: isFollowing
              ? []
              : [
                  BoxShadow(
                    color: _primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => controller.toggleFollow(user.id),
            borderRadius: BorderRadius.circular(12.0),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isFollowing ? Icons.check : Icons.add,
                    size: 16.0,
                    color: isFollowing ? _textSecondary : Colors.white,
                  ),
                  const SizedBox(width: 6.0),
                  Text(
                    isFollowing ? 'Following' : 'Connect',
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                      color: isFollowing ? _textSecondary : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSeeAllButton(String route, Color textColor) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.toNamed(route),
          borderRadius: BorderRadius.circular(12.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 10.0,
            ),
            child: Row(
              children: [
                Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(width: 6.0),
                Icon(Icons.arrow_forward_rounded, size: 16.0, color: textColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_primaryColor, _secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: _floatingShadow,
      ),
      child: FloatingActionButton(
        onPressed: () {
          // Add your action here
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(
          Icons.group_add_rounded,
          color: Colors.white,
          size: 28.0,
        ),
      ),
    );
  }

  Widget _buildBottomDecoration() {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          const SizedBox(height: 40.0),
          Container(
            height: 4.0,
            width: 60.0,
            decoration: BoxDecoration(
              color: _textTertiary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
          const SizedBox(height: 20.0),
          Text(
            'End of Results',
            style: TextStyle(
              fontSize: 14.0,
              color: _textTertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 40.0),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'therapist':
        return Colors.teal.shade300;
      case 'therapy_center':
        return Colors.teal.shade700;
      case 'patient':
        return Colors.teal.shade900;
      default:
        return const Color(0xFF0A7C8F);
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'therapist':
        return Icons.medical_information_rounded;
      case 'therapy_center':
        return Icons.spa_rounded;
      case 'patient':
        return Icons.person_rounded;
      default:
        return Icons.person_4;
    }
  }

  void _showUserProfile(UserProfile user) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.9,
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 30.0,
              spreadRadius: -5,
              offset: const Offset(0, -10),
            ),
          ],
        ),
        child: Column(
          children: [
            // Drag handle
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Center(
                child: Container(
                  width: 40.0,
                  height: 5.0,
                  decoration: BoxDecoration(
                    color: _textTertiary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            // Avatar
                          // Replace the Container widget in the profile bottom sheet
                          Container(
                          width: 100.0,
                          height: 100.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                _getRoleColor(user.role),
                                _getRoleColor(user.role).withOpacity(0.8),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: _getRoleColor(user.role).withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Container(
                              width: 92.0,
                              height: 92.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: _cardColor, width: 4.0),
                              ),
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: ProfileImageHelper.getRandomImage(user.name, user.role),
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: _getRoleColor(user.role).withOpacity(0.1),
                                    child: Center(
                                      child: Icon(
                                        _getRoleIcon(user.role),
                                        size: 36.0,
                                        color: _getRoleColor(user.role),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: _getRoleColor(user.role).withOpacity(0.1),
                                    child: Center(
                                      child: Icon(
                                        _getRoleIcon(user.role),
                                        size: 36.0,
                                        color: _getRoleColor(user.role),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                            const SizedBox(height: 24.0),
                            Text(
                              user.name,
                              style: TextStyle(
                                fontSize: 26.0,
                                fontWeight: FontWeight.w800,
                                color: _textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              decoration: BoxDecoration(
                                color: _getRoleColor(
                                  user.role,
                                ).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Text(
                                user.role.replaceAll('_', ' ').toUpperCase(),
                                style: TextStyle(
                                  fontSize: 13.0,
                                  color: _getRoleColor(user.role),
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30.0),
                      // Add more profile details here...
                      _buildProfileSection(user),
                      const SizedBox(height: 40.0),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getRoleColor(user.role),
                      shape: ContinuousRectangleBorder(borderRadius: BorderRadiusGeometry.circular(16))
                    ),
                    onPressed: () {
                      glbv.selectedUserId = user.id;
                      if(user.role=='patient')
                        {
                          Get.toNamed(RoutesConstant.patientProfile);
                        }
                      else if(user.role =='therapist') {
                        Get.toNamed(RoutesConstant.therapistProfile);
                      }
                    },
                   icon: Icon(Icons.visibility_sharp,color: Colors.white,),
                    label: Text(
                      "Visit Profile",
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getRoleColor(user.role),
                      shape: ContinuousRectangleBorder(borderRadius: BorderRadiusGeometry.circular(16))
                    ),
                    onPressed: () {},
                    icon: Icon(Iconsax.designtools,color: Colors.white,),
                    label: Text(
                      "Talk To AI",
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildProfileSection(UserProfile user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (user.specialization != null) ...[
          _buildProfileDetailItem(
            _getRoleColor(user.role),
            Icons.work_outline,
            (user.role == 'patient')?'Disorder':'Specialization',
            user.specialization!,
          ),
          const SizedBox(height: 20.0),
        ],
        if (user.location != null) ...[
          _buildProfileDetailItem(
            _getRoleColor(user.role),
            Icons.location_on_outlined,
            'Location',
            user.location!,
          ),
          const SizedBox(height: 20.0),
        ],
        _buildProfileStatsSection(user),
        const SizedBox(height: 30.0),
        if (user.bio != null) ...[
          const Divider(),
          const SizedBox(height: 20.0),
          Text(
            'About',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 12.0),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Text(
              user.bio!,
              style: TextStyle(
                fontSize: 15.0,
                color: _textSecondary,
                height: 1.6,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildProfileDetailItem(Color roleColor,IconData icon, String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24.0, color: roleColor),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: _textTertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: _textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStatsSection(UserProfile user) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildProfileStatItem( _getRoleColor(user.role),'${user.followers}', 'Followers'),
          _buildProfileStatItem( _getRoleColor(user.role),'${user.posts}', 'Posts'),
          if (user.patients != null)
            _buildProfileStatItem( _getRoleColor(user.role),'${user.patients}', 'Patients'),
          if (user.therapists != null)
            _buildProfileStatItem( _getRoleColor(user.role),'${user.therapists}', 'Therapists'),
        ],
      ),
    );
  }

  Widget _buildProfileStatItem(Color roleColor,String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.w800,
            color: roleColor,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          label,
          style: TextStyle(
            fontSize: 13.0,
            color: _textTertiary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
