import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppTextStyles {
  AppTextStyles._();

  static const _fontFamily = 'packages/mihrab_shared/PlaypenSansArabic';

  // ══════════════════════════════════════════════
  //                 HEADINGS
  // ══════════════════════════════════════════════

  static TextStyle heading1({
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 20,
      fontWeight: fontWeight ?? FontWeight.bold,
      color: color ?? Get.theme.colorScheme.inversePrimary,
      letterSpacing: letterSpacing,
      height: height ?? 1.2,
      decoration: decoration,
      fontFamily: _fontFamily,
    );
  }

  static TextStyle heading2({
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 18,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color ?? Get.theme.colorScheme.inversePrimary,
      letterSpacing: letterSpacing,
      height: height ?? 1.2,
      decoration: decoration,
      fontFamily: _fontFamily,
    );
  }

  static TextStyle heading3({
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 16,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color ?? Get.theme.colorScheme.inversePrimary,
      letterSpacing: letterSpacing,
      height: height ?? 1.2,
      decoration: decoration,
      fontFamily: _fontFamily,
    );
  }

  // ══════════════════════════════════════════════
  //                  TITLES
  // ══════════════════════════════════════════════

  static TextStyle titleLarge({
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 25,
      fontWeight: fontWeight ?? FontWeight.w700,
      color: color ?? Get.theme.colorScheme.inversePrimary,
      letterSpacing: letterSpacing,
      height: height ?? 1.5,
      decoration: decoration,
      fontFamily: _fontFamily,
    );
  }

  static TextStyle titleMedium({
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 20,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color ?? Get.theme.colorScheme.inversePrimary,
      letterSpacing: letterSpacing,
      height: height ?? 1.5,
      decoration: decoration,
      fontFamily: _fontFamily,
    );
  }

  static TextStyle titleSmall({
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 14,
      fontWeight: fontWeight ?? FontWeight.w400,
      color: color ?? Get.theme.colorScheme.inversePrimary,
      letterSpacing: letterSpacing,
      height: height ?? 1.5,
      decoration: decoration,
      fontFamily: _fontFamily,
    );
  }

  // ══════════════════════════════════════════════
  //                BODY TEXT
  // ══════════════════════════════════════════════

  static TextStyle bodyLarge({
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 22,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? Get.theme.colorScheme.inversePrimary,
      letterSpacing: letterSpacing,
      height: height ?? 1.2,
      decoration: decoration,
      fontFamily: _fontFamily,
    );
  }

  static TextStyle bodyMedium({
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 20,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? Get.theme.colorScheme.inversePrimary,
      letterSpacing: letterSpacing,
      height: height ?? 1.2,
      decoration: decoration,
      fontFamily: _fontFamily,
    );
  }

  static TextStyle bodySmall({
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    double? letterSpacing,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 18,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? Get.theme.colorScheme.inversePrimary,
      letterSpacing: letterSpacing,
      height: height ?? 1.2,
      decoration: decoration,
      fontFamily: _fontFamily,
    );
  }

  // ══════════════════════════════════════════════
  //          TV-OPTIMIZED (1.5x scaled)
  // ══════════════════════════════════════════════

  static TextStyle tvHeading({
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 48,
      fontWeight: fontWeight ?? FontWeight.bold,
      color: color ?? Get.theme.colorScheme.inversePrimary,
      fontFamily: _fontFamily,
      height: 1.3,
    );
  }

  static TextStyle tvTitle({
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 36,
      fontWeight: fontWeight ?? FontWeight.w600,
      color: color ?? Get.theme.colorScheme.inversePrimary,
      fontFamily: _fontFamily,
      height: 1.3,
    );
  }

  static TextStyle tvBody({
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 28,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? Get.theme.colorScheme.inversePrimary,
      fontFamily: _fontFamily,
      height: 1.4,
    );
  }

  static TextStyle tvCountdown({Color? color, double? fontSize}) {
    return TextStyle(
      fontSize: fontSize ?? 72,
      fontWeight: FontWeight.bold,
      color: color ?? Get.theme.colorScheme.inverseSurface,
      fontFamily: _fontFamily,
      height: 1.1,
    );
  }

  static TextStyle tvHadith({Color? color, double? fontSize}) {
    return TextStyle(
      fontSize: fontSize ?? 32,
      fontWeight: FontWeight.normal,
      color: color ?? Get.theme.colorScheme.inversePrimary,
      fontFamily: _fontFamily,
      height: 1.8,
    );
  }
}
