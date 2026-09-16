import 'dart:math' as math;
import 'package:coffee_appv2/Screens/onboarding/onboarding_screen.dart';
import 'package:coffee_appv2/core/services/auth_service.dart';
import 'package:coffee_appv2/core/themes/colors.dart';
import 'package:coffee_appv2/widget/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Cinematic KŌVÉRA Splash Screen
///
/// Features:
/// 1. Deep Espresso background with warm radial ambient glow
/// 2. Procedural animated coffee steam ribbons
/// 3. Minimalist luxury KŌVÉRA monogram badge fading & scaling
/// 4. Brand name sliding upward
/// 5. Tagline "Crafted for your moment." fading in
/// 6. Optional onFinish callback, with automatic smooth navigation to OnboardingScreen
class SplashScreen extends StatefulWidget {
  final VoidCallback? onFinish;

  const SplashScreen({super.key, this.onFinish});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _steamController;
  late AnimationController _contentController;

  late Animation<double> _badgeScale;
  late Animation<double> _badgeOpacity;
  late Animation<Offset> _brandSlide;
  late Animation<double> _brandOpacity;
  late Animation<double> _taglineOpacity;
  late Animation<Offset> _taglineSlide;

  @override
  void initState() {
    super.initState();

    // Subtle steam loop controller
    _steamController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // Content entrance timeline controller
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    // 1. Badge scale 0.85 -> 1.0 & opacity
    _badgeScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutCubic),
      ),
    );
    _badgeOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.0, 0.35, curve: Curves.easeIn),
      ),
    );

    // 2. Brand name slides upward & fades in
    _brandSlide =
        Tween<Offset>(begin: const Offset(0.0, 0.35), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _contentController,
            curve: const Interval(0.35, 0.70, curve: Curves.easeOutCubic),
          ),
        );
    _brandOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.35, 0.65, curve: Curves.easeIn),
      ),
    );

    // 3. Tagline fades in and slides slightly
    _taglineSlide =
        Tween<Offset>(begin: const Offset(0.0, 0.25), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _contentController,
            curve: const Interval(0.65, 0.95, curve: Curves.easeOutCubic),
          ),
        );
    _taglineOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.65, 0.95, curve: Curves.easeIn),
      ),
    );

    _contentController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        if (widget.onFinish != null) {
          widget.onFinish!();
        } else {
          final currentUser = AuthService.instance.currentUser;
          final Widget nextScreen = currentUser != null
              ? const BottomNavBar()
              : const OnboardingScreen();

          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 700),
              pageBuilder: (context, animation, secondaryAnimation) =>
                  nextScreen,
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _steamController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepEspresso,
      body: Stack(
        children: [
          // Subtle warm radial ambient glow in center
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.0, -0.1),
                  radius: 0.8,
                  colors: [
                    Color(0xFF35221B), // Soft warm roasted undertone
                    AppColors.deepEspresso,
                  ],
                  stops: [0.0, 1.0],
                ),
              ),
            ),
          ),

          // Central Brand Lockup
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Procedural Steam Animation
                AnimatedBuilder(
                  animation: _steamController,
                  builder: (context, child) {
                    return CustomPaint(
                      size: const Size(60, 48),
                      painter: _CoffeeSteamPainter(
                        progress: _steamController.value,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 8),

                // Monogram Badge
                AnimatedBuilder(
                  animation: _contentController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _badgeScale.value,
                      child: Opacity(
                        opacity: _badgeOpacity.value,
                        child: child,
                      ),
                    );
                  },
                  child: Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      color: AppColors.roastedCocoa,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.burntCaramel.withValues(alpha: 0.4),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.burntCaramel.withValues(alpha: 0.25),
                          blurRadius: 30,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'K',
                        style: GoogleFonts.playfairDisplay(
                          color: AppColors.softAmber,
                          fontSize: 44,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Brand Name "KŌVÉRA"
                AnimatedBuilder(
                  animation: _contentController,
                  builder: (context, child) {
                    return SlideTransition(
                      position: _brandSlide,
                      child: Opacity(
                        opacity: _brandOpacity.value,
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Text(
                        'KŌVÉRA',
                        style: GoogleFonts.playfairDisplay(
                          color: AppColors.warmPorcelain,
                          letterSpacing: 7.0,
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 36,
                        height: 2,
                        decoration: BoxDecoration(
                          color: AppColors.burntCaramel,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Tagline "Crafted for your moment."
                AnimatedBuilder(
                  animation: _contentController,
                  builder: (context, child) {
                    return SlideTransition(
                      position: _taglineSlide,
                      child: Opacity(
                        opacity: _taglineOpacity.value,
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    'Crafted for your moment.',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.lightTextSecondary,
                      letterSpacing: 1.2,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter rendering organic rising coffee steam ribbons
class _CoffeeSteamPainter extends CustomPainter {
  final double progress;

  _CoffeeSteamPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final steamColors = [
      AppColors.softAmber.withValues(alpha: 0.35 * (1.0 - progress)),
      AppColors.burntCaramel.withValues(alpha: 0.45 * (1.0 - progress)),
      AppColors.softAmber.withValues(alpha: 0.30 * (1.0 - progress)),
    ];

    for (int i = 0; i < 3; i++) {
      paint.color = steamColors[i];
      final path = Path();
      final startX = size.width * (0.3 + i * 0.2);
      final waveOffset = (progress * 2 * math.pi) + (i * 1.5);
      final height = size.height * (0.6 + 0.4 * progress);

      path.moveTo(startX, size.height);
      path.quadraticBezierTo(
        startX + math.sin(waveOffset) * 6,
        size.height - (height * 0.5),
        startX - math.sin(waveOffset) * 4,
        size.height - height,
      );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CoffeeSteamPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
