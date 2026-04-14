import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// App theme matching the Mihrab design system
class AppTheme {
  AppTheme._();

  static const _fontFamily = 'packages/mihrab_shared/PlaypenSansArabic';

  static ThemeData get light {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: _fontFamily,
      scaffoldBackgroundColor: AppColors.whiteCream,
      primaryColor: AppColors.primaryDarkGreen,
      primaryColorLight: AppColors.lightOlive,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryDarkGreen,
        secondary: AppColors.mediumGreen,
        tertiary: AppColors.tealGreen,
        surface: AppColors.goldAmber,
        onSurface: AppColors.darkText,
        inversePrimary: AppColors.darkText,
        inverseSurface: AppColors.goldAmber,
        primaryContainer: AppColors.sand,
        secondaryContainer: AppColors.warmCream,
      ),
      cardColor: AppColors.warmCream,
      dividerColor: AppColors.lightOlive,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.darkText),
        bodyMedium: TextStyle(color: AppColors.darkText),
        bodySmall: TextStyle(color: AppColors.darkText),
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: _fontFamily,
      scaffoldBackgroundColor: AppColors.darkBackground,
      primaryColor: AppColors.primaryDarkGreen,
      primaryColorLight: AppColors.darkCard,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryDarkGreen,
        secondary: AppColors.mediumGreen,
        tertiary: AppColors.tealGreen,
        surface: AppColors.goldAmber,
        onSurface: AppColors.warmWhiteText,
        inversePrimary: AppColors.warmWhiteText,
        inverseSurface: AppColors.goldAmber,
        primaryContainer: AppColors.darkSurface,
        secondaryContainer: AppColors.darkCard,
      ),
      cardColor: AppColors.darkCard,
      dividerColor: AppColors.darkSurface,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.warmWhiteText),
        bodyMedium: TextStyle(color: AppColors.warmWhiteText),
        bodySmall: TextStyle(color: AppColors.warmWhiteText),
      ),
    );
  }

  // ══════════════════════════════════════════════
  //           MIDNIGHT BLUE THEME
  // ══════════════════════════════════════════════

  static ThemeData get midnightBlueLight {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: _fontFamily,
      scaffoldBackgroundColor: AppColors.midnightNavy,
      primaryColor: AppColors.midnightBlue,
      primaryColorLight: AppColors.midnightSurface,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.midnightBlue,
        secondary: AppColors.midnightLightBlue,
        tertiary: AppColors.midnightLightBlue,
        surface: AppColors.midnightGold,
        onSurface: AppColors.midnightText,
        inversePrimary: AppColors.midnightText,
        inverseSurface: AppColors.midnightGold,
        primaryContainer: AppColors.midnightSurface,
        secondaryContainer: AppColors.midnightSurface,
      ),
      cardColor: AppColors.midnightSurface,
      dividerColor: AppColors.midnightBlue,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.midnightText),
        bodyMedium: TextStyle(color: AppColors.midnightText),
        bodySmall: TextStyle(color: AppColors.midnightText),
      ),
    );
  }

  static ThemeData get midnightBlueDark {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: _fontFamily,
      scaffoldBackgroundColor: const Color(0xFF070F18),
      primaryColor: AppColors.midnightBlue,
      primaryColorLight: const Color(0xFF0A1520),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.midnightBlue,
        secondary: AppColors.midnightLightBlue,
        tertiary: AppColors.midnightLightBlue,
        surface: AppColors.midnightGold,
        onSurface: AppColors.midnightText,
        inversePrimary: AppColors.midnightText,
        inverseSurface: AppColors.midnightGold,
        primaryContainer: Color(0xFF0A1520),
        secondaryContainer: Color(0xFF0D1925),
      ),
      cardColor: const Color(0xFF0D1925),
      dividerColor: AppColors.midnightBlue,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.midnightText),
        bodyMedium: TextStyle(color: AppColors.midnightText),
        bodySmall: TextStyle(color: AppColors.midnightText),
      ),
    );
  }

  // ══════════════════════════════════════════════
  //           MOSQUE GREEN THEME
  // ══════════════════════════════════════════════

  static ThemeData get mosqueGreenLight {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: _fontFamily,
      scaffoldBackgroundColor: AppColors.mosqueForest,
      primaryColor: AppColors.mosqueEmerald,
      primaryColorLight: AppColors.mosqueSurface,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.mosqueEmerald,
        secondary: AppColors.mosqueLightGreen,
        tertiary: AppColors.mosqueLightGreen,
        surface: AppColors.mosqueGold,
        onSurface: AppColors.mosqueCream,
        inversePrimary: AppColors.mosqueCream,
        inverseSurface: AppColors.mosqueGold,
        primaryContainer: AppColors.mosqueSurface,
        secondaryContainer: AppColors.mosqueSurface,
      ),
      cardColor: AppColors.mosqueSurface,
      dividerColor: AppColors.mosqueEmerald,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.mosqueCream),
        bodyMedium: TextStyle(color: AppColors.mosqueCream),
        bodySmall: TextStyle(color: AppColors.mosqueCream),
      ),
    );
  }

  static ThemeData get mosqueGreenDark {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: _fontFamily,
      scaffoldBackgroundColor: const Color(0xFF112A20),
      primaryColor: AppColors.mosqueEmerald,
      primaryColorLight: const Color(0xFF1A3A2C),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.mosqueEmerald,
        secondary: AppColors.mosqueLightGreen,
        tertiary: AppColors.mosqueLightGreen,
        surface: AppColors.mosqueGold,
        onSurface: AppColors.mosqueCream,
        inversePrimary: AppColors.mosqueCream,
        inverseSurface: AppColors.mosqueGold,
        primaryContainer: Color(0xFF1A3A2C),
        secondaryContainer: Color(0xFF1E4233),
      ),
      cardColor: const Color(0xFF1E4233),
      dividerColor: AppColors.mosqueEmerald,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.mosqueCream),
        bodyMedium: TextStyle(color: AppColors.mosqueCream),
        bodySmall: TextStyle(color: AppColors.mosqueCream),
      ),
    );
  }

  /// Factory method to get the correct theme by name and dark mode
  static ThemeData getTheme(String themeName, bool isDark) {
    switch (themeName) {
      case 'midnight_blue':
        return isDark ? midnightBlueDark : midnightBlueLight;
      case 'mosque_green':
        return isDark ? mosqueGreenDark : mosqueGreenLight;
      case 'classic':
      default:
        return isDark ? dark : light;
    }
  }

  /// Get the dark variant for a given theme name
  static ThemeData getDarkTheme(String themeName) {
    switch (themeName) {
      case 'midnight_blue':
        return midnightBlueDark;
      case 'mosque_green':
        return mosqueGreenDark;
      case 'classic':
      default:
        return dark;
    }
  }

  /// Get the light variant for a given theme name
  static ThemeData getLightTheme(String themeName) {
    switch (themeName) {
      case 'midnight_blue':
        return midnightBlueLight;
      case 'mosque_green':
        return mosqueGreenLight;
      case 'classic':
      default:
        return light;
    }
  }
}
