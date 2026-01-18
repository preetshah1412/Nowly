import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary Brand Colors
  static const Color primary = Color(0xFFE63946); // Emergency Red
  static const Color primaryDark = Color(0xFFB71C1C);
  static const Color secondary = Color(0xFF1D3557); // Deep Blue
  static const Color secondaryLight = Color(0xFF457B9D);

  static const Color background = Color(0xFFF1F5F9); // Crisp Off-white
  static const Color surface = Colors.white;
  static const Color surfaceGlass = Color(0xCCFFFFFF); // Semi-transparent white

  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF2A9D8F);
  static const Color warning = Color(0xFFE9C46A);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFFFF5F6D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [secondary, Color(0xFF457B9D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.outfit().fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: secondary,
        background: background,
        surface: surface,
        error: error,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: background,

      // Typography
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        displayLarge: GoogleFonts.outfit(
          fontSize: 36,
          fontWeight: FontWeight.w800,
          color: secondary,
          letterSpacing: -1.0,
        ),
        displayMedium: GoogleFonts.outfit(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: secondary,
          letterSpacing: -0.5,
        ),
        titleLarge: GoogleFonts.outfit(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: secondary,
        ),
        bodyLarge: GoogleFonts.outfit(
          fontSize: 16,
          color: const Color(0xFF334155), // Slate 700
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: GoogleFonts.outfit(
          fontSize: 14,
          color: const Color(0xFF64748B), // Slate 500
        ),
      ),

      // Button Styling
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: primary.withOpacity(0.4),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.blueGrey.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),
        hintStyle: GoogleFonts.outfit(color: Colors.grey.shade400),
        prefixIconColor: secondaryLight,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: secondary,
        size: 24,
      ),
    );
  }
}
