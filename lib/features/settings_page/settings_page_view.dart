import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:myapp/features/settings_page/settings_page_controller.dart';

class SettingsPageView extends GetView<SettingsPageController> {
  static  Color primaryTeal = Colors.teal.shade900;
  static const Color darkTeal = Color(0xFF004D4D);
  static const Color lightTeal = Color(0xFFE0F7FA);
  static const Color accentTeal = Color(0xFF4DB6AC);
  static const Color luxuryGold = Color(0xFFD4AF37);
  static const Color luxuryGray = Color(0xFF2C2C2C);
  static const Color premiumWhite = Color(0xFFFAFAFA);

  static const Gradient primaryGradient =LinearGradient(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: premiumWhite,
      body: CustomScrollView(
        slivers: [
          // Premium App Bar
          SliverAppBar(
            expandedHeight: 200,
            collapsedHeight: 80,
            floating: true,
            pinned: true,

            title: Text(
              'Settings',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            shape: ContinuousRectangleBorder(borderRadius: BorderRadiusGeometry.only(bottomRight: Radius.circular(100),bottomLeft: Radius.circular(100))),
            backgroundColor: Colors.teal.shade900,
            centerTitle: true,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Container(
                decoration: BoxDecoration(
                  gradient: luxuryGradient,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                    bottom: 24,
                    top: 60,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: primaryGradient,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryTeal.withOpacity(0.3),
                                  blurRadius: 15,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Iconsax.setting_2,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Settings',
                                  style: GoogleFonts.playfairDisplay(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Premium Configuration Center',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            ),
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

          ),

          // Settings Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
                  // Premium Profile Section
                  _buildPremiumProfileCard(),
                  const SizedBox(height: 24),

                  // Account Settings Section
                  _buildSettingsSection(
                    title: 'Account',
                    subtitle: 'Manage your personal information',
                    icon: Iconsax.profile_circle,
                    items: [
                      _buildSettingsItem(
                        icon: Iconsax.user,
                        title: 'Personal Information',
                        subtitle: 'Update your details',
                        hasArrow: true,

                      ),
                      _buildSettingsItem(
                        icon: Iconsax.shield_tick,
                        title: 'Privacy & Security',
                        subtitle: 'Manage your security settings',
                        hasArrow: true,
                      ),
                      _buildSettingsItem(
                        icon: Iconsax.card,
                        title: 'Subscription',
                        subtitle: 'Premium Plan - Active',
                        hasArrow: true,
                        badge: 'VIP',
                        isActive: true,
                      ),
                      _buildSettingsItem(
                        icon: Iconsax.notification,
                        title: 'Notifications',
                        subtitle: 'Configure alerts',
                        hasArrow: true,
                        hasSwitch: true,
                        isSwitchOn: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // App Preferences Section
                  _buildSettingsSection(
                    title: 'Preferences',
                    subtitle: 'Customize your experience',
                    icon: Iconsax.setting_3,
                    items: [
                      _buildSettingsItem(
                        icon: Iconsax.moon,
                        title: 'Theme',
                        subtitle: 'Dark Mode',
                        hasArrow: true,
                        hasSwitch: true,
                        isSwitchOn: false,
                      ),
                      _buildSettingsItem(
                        icon: Iconsax.global,
                        title: 'Language',
                        subtitle: 'English (US)',
                        hasArrow: true,
                      ),
                      _buildSettingsItem(
                        icon: Iconsax.activity,
                        title: 'Accessibility',
                        subtitle: 'Display & Text Size',
                        hasArrow: true,
                      ),
                      _buildSettingsItem(
                        icon: Iconsax.data,
                        title: 'Data & Storage',
                        subtitle: 'Manage cache and data',
                        hasArrow: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Support Section
                  _buildSettingsSection(
                    title: 'Support',
                    subtitle: 'Get help and support',
                    icon: Iconsax.headphone,
                    items: [
                      _buildSettingsItem(
                        icon: Iconsax.message_question,
                        title: 'Help Center',
                        subtitle: 'Browse FAQs and guides',
                        hasArrow: true,
                      ),
                      _buildSettingsItem(
                        icon: Iconsax.message,
                        title: 'Contact Support',
                        subtitle: '24/7 Premium Support',
                        hasArrow: true,
                        badge: 'Priority',
                      ),
                      _buildSettingsItem(
                        icon: Iconsax.document_text,
                        title: 'Terms & Policies',
                        subtitle: 'Legal information',
                        hasArrow: true,
                      ),
                      _buildSettingsItem(
                        icon: Iconsax.info_circle,
                        title: 'About NaiviSense',
                        subtitle: 'Version 2.1.0',
                        hasArrow: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Advanced Section
                  _buildSettingsSection(
                    title: 'Advanced',
                    subtitle: 'Developer & experimental features',
                    icon: Iconsax.code,
                    items: [
                      _buildSettingsItem(
                        icon: Iconsax.document_download,
                        title: 'Export Data',
                        subtitle: 'Download your information',
                        hasArrow: true,
                      ),
                      _buildSettingsItem(
                        icon: Iconsax.cpu,
                        title: 'Experimental Features',
                        subtitle: 'Try new features early',
                        hasArrow: true,
                      ),
                      _buildSettingsItem(
                        icon: Iconsax.shield_security,
                        title: 'Clear All Data',
                        subtitle: 'Reset to factory settings',
                        isDanger: true,
                        hasArrow: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Logout Button
                  _buildLogoutButton(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.teal.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.link,
                        color: Colors.teal[700],
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Enter Just your Id",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.teal[900],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: controller.linkcontroller,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.teal[50],
                      hintText: "eb03fe9b948c",
                      prefixText: "wss://",
                      suffixText: ".ngrok-free.app",
                      hintStyle: TextStyle(color: Colors.teal[300]),
                      prefixIcon: Icon(Icons.http, color: Colors.teal[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.teal[100]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.teal[400]!, width: 2),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.teal[900],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.saveUrl(controller.linkcontroller.text);

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        shadowColor: Colors.teal.withOpacity(0.3),
                      ),
                      child: const Text(
                        "Save URL",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),



          )
        ],
      ),
    );
  }

  Widget _buildPremiumProfileCard() {
    return Container(
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
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryTeal.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: primaryGradient,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryTeal.withOpacity(0.3),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Stack(
              children: [
                const Center(
                  child: Icon(
                    Iconsax.user,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    width: 24,
                    height: 24,
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
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Alex Johnson',
                  style: GoogleFonts.poppins(
                    color: luxuryGray,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Premium Member',
                  style: GoogleFonts.poppins(
                    color: luxuryGold,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: primaryTeal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: primaryTeal.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Iconsax.crown_1,
                        size: 14,
                        color: luxuryGold,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Therapist',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: primaryTeal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(
                Iconsax.edit_2,
                color: primaryTeal,
                size: 20,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required List<Widget> items,
  }) {
    return Container(
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
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: lightTeal.withOpacity(0.3),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              border: Border(
                bottom: BorderSide(
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
                    boxShadow: [
                      BoxShadow(
                        color: primaryTeal.withOpacity(0.2),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          color: luxuryGray,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          color: luxuryGray.withOpacity(0.6),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Section Items
          ...items,
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    bool hasArrow = false,
    bool hasSwitch = false,
    bool isSwitchOn = false,
    bool isActive = false,
    bool isDanger = false,
    String? badge,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade100,
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isDanger
                    ? Colors.red.withOpacity(0.1)
                    : (isActive
                    ? primaryTeal.withOpacity(0.1)
                    : luxuryGray.withOpacity(0.08)),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDanger
                      ? Colors.red.withOpacity(0.2)
                      : (isActive
                      ? primaryTeal.withOpacity(0.3)
                      : Colors.transparent),
                  width: 1.5,
                ),
              ),
              child: Icon(
                icon,
                color: isDanger
                    ? Colors.red
                    : (isActive ? primaryTeal : luxuryGray.withOpacity(0.7)),
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
                        title,
                        style: GoogleFonts.poppins(
                          color: isDanger ? Colors.red : luxuryGray,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
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
                                ? luxuryGold.withOpacity(0.1)
                                : badge == "Verified"
                                ? Colors.green.withOpacity(0.1)
                                : primaryTeal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: badge == "VIP"
                                  ? luxuryGold.withOpacity(0.3)
                                  : badge == "Verified"
                                  ? Colors.green.withOpacity(0.3)
                                  : primaryTeal.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            badge,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: badge == "VIP"
                                  ? luxuryGold
                                  : badge == "Verified"
                                  ? Colors.green
                                  : primaryTeal,
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
                      color: isDanger
                          ? Colors.red.withOpacity(0.8)
                          : luxuryGray.withOpacity(0.6),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            if (hasSwitch)
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: isSwitchOn,
                  onChanged: (value) {},
                  activeColor: primaryTeal,
                  activeTrackColor: primaryTeal.withOpacity(0.3),
                  inactiveThumbColor: Colors.grey.shade400,
                  inactiveTrackColor: Colors.grey.shade200,
                ),
              ),
            if (hasArrow && !hasSwitch)
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey.shade100,
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Iconsax.arrow_right_3,
                  color: luxuryGray.withOpacity(0.5),
                  size: 18,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
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
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: () {
            // Logout logic
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.red.withOpacity(0.2),
                        Colors.red.withOpacity(0.1),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.red.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Iconsax.logout_1,
                    color: Colors.red,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Log Out',
                        style: GoogleFonts.poppins(
                          color: luxuryGray,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Sign out from all devices',
                        style: GoogleFonts.poppins(
                          color: luxuryGray.withOpacity(0.6),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.red.withOpacity(0.2),
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Iconsax.arrow_right_3,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}