import 'package:coffee_appv2/Screens/login/login_screen.dart';
import 'package:coffee_appv2/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Represents an onboarding page data item
class OnboardingData {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String tag;

  const OnboardingData({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.tag,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = const [
    OnboardingData(
      tag: "ARTISANAL ROASTS",
      title: "Awaken Your Senses\nWith Pure Craft",
      subtitle:
          "Single-origin specialty coffee meticulously roasted to bring out the richest flavor notes.",
      imageUrl:
          "https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb?q=80&w=1078&auto=format&fit=crop",
    ),
    OnboardingData(
      tag: "FRESHLY BAKED",
      title: "Handcrafted Treats\nBaked Daily",
      subtitle:
          "Pair your coffee with decadent Basque cheesecakes, artisan cookies, and flaky pastries.",
      imageUrl:
          "https://images.unsplash.com/photo-1555507036-ab1f4038808a?q=80&w=1026&auto=format&fit=crop",
    ),
    OnboardingData(
      tag: "SEAMLESS ORDERING",
      title: "Fast Pickup &\nArtisan Delivery",
      subtitle:
          "Order your personalized brew ahead and have it fresh and ready right at your door or table.",
      imageUrl:
          "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?q=80&w=1170&auto=format&fit=crop",
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _onGetStarted();
    }
  }

  void _onGetStarted() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isShortScreen = size.height < 700;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          // Background PageView with images
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    page.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.deepEspresso,
                        child: const Center(
                          child: Icon(
                            Icons.coffee_rounded,
                            color: AppColors.burntCaramel,
                            size: 64,
                          ),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: AppColors.deepEspresso,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.burntCaramel,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
                  ),
                  // Dark Luxury Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.0, 0.45, 0.8, 1.0],
                        colors: [
                          Colors.black.withValues(alpha: 0.35),
                          Colors.transparent,
                          AppColors.darkBackground.withValues(alpha: 0.85),
                          AppColors.darkBackground,
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Top Header (Skip Button & Brand)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "K Ō V É R A",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3,
                      color: AppColors.warmPorcelain,
                    ),
                  ),
                  if (_currentPage < _pages.length - 1)
                    TextButton(
                      onPressed: _onGetStarted,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        backgroundColor: Colors.black.withValues(alpha: 0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        "Skip",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.warmPorcelain,
                        ),
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                ],
              ),
            ),
          ),

          // Bottom Content Card
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tag Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.burntCaramel.withValues(alpha: 0.2),
                        border: Border.all(
                          color: AppColors.burntCaramel.withValues(alpha: 0.6),
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        _pages[_currentPage].tag,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: AppColors.burntCaramel,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Title
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        _pages[_currentPage].title,
                        key: ValueKey('title_$_currentPage'),
                        style: GoogleFonts.playfairDisplay(
                          fontSize: isShortScreen ? 26 : 32,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                          color: AppColors.warmPorcelain,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Subtitle
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        _pages[_currentPage].subtitle,
                        key: ValueKey('sub_$_currentPage'),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: isShortScreen ? 13 : 14,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Page Indicators & Next / Get Started Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Dots Indicator
                        Row(
                          children: List.generate(_pages.length, (index) {
                            final isActive = _currentPage == index;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.only(right: 6),
                              height: 6,
                              width: isActive ? 24 : 6,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppColors.burntCaramel
                                    : AppColors.mutedTaupe.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            );
                          }),
                        ),

                        // Action Button
                        ElevatedButton(
                          onPressed: _onNext,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.burntCaramel,
                            foregroundColor: AppColors.warmPorcelain,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _currentPage == _pages.length - 1
                                    ? "Get Started"
                                    : "Next",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                size: 16,
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
        ],
      ),
    );
  }
}
