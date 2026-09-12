import 'package:flutter/material.dart';

/// KŌVÉRA Centralized Color Palette
///
/// Deep Espresso & Burnt Caramel theme with warm porcelain tones.
/// Avoids generic brown coffee styling in favor of modern luxury coffee culture.
class AppColors {
  AppColors._();

  // Primary Palette
  static const Color deepEspresso = Color(0xFF201613);
  static const Color roastedCocoa = Color(0xFF3A2721);
  static const Color burntCaramel = Color(0xFFC47A45);
  static const Color softAmber = Color(0xFFD99A63);
  static const Color warmPorcelain = Color(0xFFF6F0E7);
  static const Color latteMist = Color(0xFFEDE2D5);
  static const Color coffeeLatex = Color(0xFFF0E8DB);

  // Text Colors
  static const Color espressoText = Color(0xFF211A17);
  static const Color mutedTaupe = Color(0xFF897970);
  static const Color lightTextPrimary = Color(0xFFF8F0E7);
  static const Color lightTextSecondary = Color(0xFFB8A79D);

  // Status & Utility Colors
  static const Color success = Color(0xFF54735B);
  static const Color error = Color(0xFFB94A48);
  static const Color transparent = Colors.transparent;

  // Dark Mode Palette ("KŌVÉRA after sunset")
  static const Color darkBackground = Color(0xFF15100E);
  static const Color darkSurface = Color(0xFF211815);
  static const Color darkCard = Color(0xFF2B201C);
  static const Color darkAccent = Color(0xFFD28A54);
  static const Color darkTextPrimary = Color(0xFFF8F0E7);
  static const Color darkTextSecondary = Color(0xFFB8A79D);

  // Subtle Border / Divider Colors
  static const Color borderLight = Color(0x1A3A2721); // ~10% roasted cocoa
  static const Color borderDark = Color(0x26D99A63); // ~15% soft amber

  // Shadow Colors (soft, diffuse, never harsh black)
  static const Color shadowLight = Color(0x14201613); // 8% opacity
  static const Color shadowDark = Color(0x40000000); // 25% black
}
