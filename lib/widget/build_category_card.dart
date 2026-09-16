import 'package:coffee_appv2/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Buildcategorycard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;

  const Buildcategorycard({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: isActive ? AppColors.burntCaramel : Colors.white,
          boxShadow: [
            if (isActive)
              BoxShadow(
                color: AppColors.burntCaramel.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            else
              const BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? Colors.white : AppColors.burntCaramel,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? Colors.white : AppColors.espressoText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
