import 'package:coffee_appv2/Screens/login/login_screen.dart';
import 'package:coffee_appv2/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _pushNotifications = true;
  bool _newsletter = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.latteMist,
      appBar: AppBar(
        backgroundColor: AppColors.latteMist,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Profile",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.deepEspresso,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              color: AppColors.deepEspresso,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Settings"),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
        child: Column(
          children: [
            // User Header Card
            _buildProfileHeader(),
            const SizedBox(height: 20),

            // Loyalty / Coffee Club Membership Card
            _buildClubMembershipCard(),
            const SizedBox(height: 24),

            // Account & Preferences Section
            _buildSectionHeader("Account & Activity"),
            const SizedBox(height: 10),
            _buildMenuContainer([
              _buildMenuItem(
                icon: Icons.history_rounded,
                title: "Order History",
                subtitle: "14 orders completed",
                onTap: () {},
              ),
              _buildDivider(),
              _buildMenuItem(
                icon: Icons.credit_card_rounded,
                title: "Payment Methods",
                subtitle: "Apple Pay, Visa ending in 4289",
                onTap: () {},
              ),
              _buildDivider(),
              _buildMenuItem(
                icon: Icons.location_on_outlined,
                title: "Delivery Addresses",
                subtitle: "Home, Office",
                onTap: () {},
              ),
              _buildDivider(),
              _buildMenuItem(
                icon: Icons.card_giftcard_rounded,
                title: "Vouchers & Rewards",
                trailingWidget: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.burntCaramel.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "3 Active",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.burntCaramel,
                    ),
                  ),
                ),
                onTap: () {},
              ),
            ]),
            const SizedBox(height: 24),

            // App Settings Section
            _buildSectionHeader("Preferences"),
            const SizedBox(height: 10),
            _buildMenuContainer([
              _buildSwitchItem(
                icon: Icons.notifications_none_rounded,
                title: "Order Notifications",
                value: _pushNotifications,
                onChanged: (val) {
                  setState(() => _pushNotifications = val);
                },
              ),
              _buildDivider(),
              _buildSwitchItem(
                icon: Icons.mail_outline_rounded,
                title: "Coffee Digest & Offers",
                value: _newsletter,
                onChanged: (val) {
                  setState(() => _newsletter = val);
                },
              ),
              _buildDivider(),
              _buildMenuItem(
                icon: Icons.security_rounded,
                title: "Privacy & Security",
                onTap: () {},
              ),
            ]),
            const SizedBox(height: 24),

            // Support & Sign Out
            _buildMenuContainer([
              _buildMenuItem(
                icon: Icons.help_outline_rounded,
                title: "Help & Concierge",
                onTap: () {},
              ),
              _buildDivider(),
              _buildMenuItem(
                icon: Icons.logout_rounded,
                title: "Sign Out",
                titleColor: AppColors.error,
                iconColor: AppColors.error,
                showArrow: false,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: AppColors.warmPorcelain,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: Text(
                        "Sign Out",
                        style: GoogleFonts.playfairDisplay(
                          fontWeight: FontWeight.w700,
                          color: AppColors.deepEspresso,
                        ),
                      ),
                      content: Text(
                        "Are you sure you want to sign out of KŌVÉRA?",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          color: AppColors.espressoText,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.mutedTaupe,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.burntCaramel,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(ctx);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                              (route) => false,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Signed out successfully"),
                                backgroundColor: AppColors.deepEspresso,
                              ),
                            );
                          },
                          child: const Text("Sign Out"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ]),
            const SizedBox(height: 30),

            // App Version Footer
            Text(
              "KŌVÉRA v2.0.4 • Artisan Roastery Experience",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.mutedTaupe.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.warmPorcelain,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.burntCaramel, width: 2),
              color: AppColors.latteMist,
            ),
            child: const CircleAvatar(
              backgroundColor: AppColors.latteMist,
              child: Icon(
                Icons.person_rounded,
                size: 38,
                color: AppColors.burntCaramel,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // User Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        "Alex Thorne",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.deepEspresso,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.verified_rounded,
                      size: 18,
                      color: AppColors.burntCaramel,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "alex.thorne@kovera.coffee",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppColors.mutedTaupe,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.burntCaramel.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Gold Tier Connoisseur",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.burntCaramel,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Edit Button
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Edit Profile")));
            },
            icon: const Icon(
              Icons.edit_outlined,
              size: 20,
              color: AppColors.burntCaramel,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClubMembershipCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.deepEspresso,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepEspresso.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.local_cafe_rounded,
                    color: AppColors.softAmber,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "KŌVÉRA CLUB",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      color: AppColors.softAmber,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.roastedCocoa,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.softAmber.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  "Gold Member",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            "Coffee Points Balance",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                "840",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                "/ 1,000 pts for free Artisan Reserve",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: 0.84,
              minHeight: 7,
              backgroundColor: AppColors.roastedCocoa,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.burntCaramel,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.deepEspresso,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildMenuContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.warmPorcelain,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? titleColor,
    Color? iconColor,
    Widget? trailingWidget,
    bool showArrow = true,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (iconColor ?? AppColors.burntCaramel).withValues(
                  alpha: 0.1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 20,
                color: iconColor ?? AppColors.burntCaramel,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: titleColor ?? AppColors.deepEspresso,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.mutedTaupe,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            ?trailingWidget,
            if (showArrow) ...[
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppColors.mutedTaupe,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.burntCaramel.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: AppColors.burntCaramel),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.deepEspresso,
              ),
            ),
          ),
          Switch.adaptive(
            value: value,
            activeTrackColor: AppColors.burntCaramel,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 52,
      endIndent: 16,
      color: AppColors.borderLight,
    );
  }
}
