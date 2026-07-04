import 'package:flutter/material.dart';

class AppTheme {
  static const double kBorderRadius = 12.0;

  // Custom harmonious palette
  static const Color kPrimaryLight = Color(0xFF6366F1); // Indigo
  static const Color kPrimaryDark = Color(0xFF818CF8);

  static const Color kSecondaryLight = Color(0xFF0D9488); // Teal
  static const Color kSecondaryDark = Color(0xFF2DD4BF);

  static const Color kBackgroundLight = Color(0xFFF8FAFC); // Slate background
  static const Color kBackgroundDark = Color(0xFF0F172A);

  static const Color kSurfaceLight = Color(0xFFFFFFFF);
  static const Color kSurfaceDark = Color(0xFF1E293B);

  static const Color kTextLight = Color(0xFF1E293B);
  static const Color kTextDark = Color(0xFFF1F5F9);

  static const Color kError = Color(0xFFEF4444);

  // Custom slate colors to replace missing Colors.slate in Flutter Material
  static const Color kSlate100 = Color(0xFFF1F5F9);
  static const Color kSlate200 = Color(0xFFE2E8F0);
  static const Color kSlate800 = Color(0xFF1E293B);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: kPrimaryLight,
        secondary: kSecondaryLight,
        background: kBackgroundLight,
        surface: kSurfaceLight,
        error: kError,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: kTextLight,
        onSurface: kTextLight,
      ),
      scaffoldBackgroundColor: kBackgroundLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: kSurfaceLight,
        foregroundColor: kTextLight,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: kSurfaceLight,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          side: const BorderSide(color: kSlate100),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: const BorderSide(color: kSlate200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: const BorderSide(color: kSlate200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: const BorderSide(color: kPrimaryLight, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: const BorderSide(color: kError, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryLight,
          foregroundColor: Colors.white,
          minimumSize: const Size(88, 48),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: kPrimaryLight,
          side: const BorderSide(color: kPrimaryLight),
          minimumSize: const Size(88, 48),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: kPrimaryDark,
        secondary: kSecondaryDark,
        background: kBackgroundDark,
        surface: kSurfaceDark,
        error: kError,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onBackground: kTextDark,
        onSurface: kTextDark,
      ),
      scaffoldBackgroundColor: kBackgroundDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: kSurfaceDark,
        foregroundColor: kTextDark,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: kSurfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          side: const BorderSide(color: kSlate800),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: kSurfaceDark,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: const BorderSide(color: kSlate800),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: const BorderSide(color: kSlate800),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: const BorderSide(color: kPrimaryDark, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: const BorderSide(color: kError, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryDark,
          foregroundColor: Colors.black,
          minimumSize: const Size(88, 48),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: kPrimaryDark,
          side: const BorderSide(color: kPrimaryDark),
          minimumSize: const Size(88, 48),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
        ),
      ),
    );
  }
}
