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
}
