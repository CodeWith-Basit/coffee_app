import 'package:coffee_appv2/Screens/Home/home_screen.dart';
import 'package:coffee_appv2/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavBar extends StatefulWidget {
  final int initialIndex;
  const BottomNavBar({super.key, this.initialIndex = 0});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late int activeTab;
  late List<int> tabHistory;

  final List<Map<String, dynamic>> _navItems = const [
    {"icon": Icons.home_rounded, "label": "Home"},
    {"icon": Icons.storefront_rounded, "label": "Shop"},
    {"icon": Icons.explore_rounded, "label": "Explore"},
    {"icon": Icons.local_mall_rounded, "label": "Cart"},
    {"icon": Icons.person_rounded, "label": "Profile"},
  ];

  @override
  void initState() {
    super.initState();
    activeTab = widget.initialIndex;
    tabHistory = [widget.initialIndex];
  }

  void changeTab(int index) {
    if (activeTab == index) return;
    setState(() {
      activeTab = index;
      if (tabHistory.isEmpty || tabHistory.last != index) {
        tabHistory.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomeScreen(),
      const Center(child: Text("Shop Screen")),
      const Center(child: Text("Explore Screen")),
      const Center(child: Text("Cart Screen")),
      const Center(child: Text("Profile Screen")),
    ];

    return PopScope(
      canPop: tabHistory.length <= 1,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        setState(() {
          tabHistory.removeLast();
          activeTab = tabHistory.last;
        });
      },
      child: Scaffold(
        backgroundColor: AppColors.latteMist,
        body: IndexedStack(index: activeTab, children: screens),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 18,
            top: 6,
          ),
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: AppColors.burntCaramel.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(color: AppColors.borderLight, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_navItems.length, (index) {
                final item = _navItems[index];
                final bool isActive = activeTab == index;

                return GestureDetector(
                  onTap: () => changeTab(index),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    padding: EdgeInsets.symmetric(
                      horizontal: isActive ? 14 : 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.burntCaramel
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color: AppColors.burntCaramel.withValues(
                                  alpha: 0.35,
                                ),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item["icon"] as IconData,
                          size: 22,
                          color: isActive ? Colors.white : AppColors.mutedTaupe,
                        ),
                        if (isActive) ...[
                          const SizedBox(width: 6),
                          Text(
                            item["label"] as String,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
