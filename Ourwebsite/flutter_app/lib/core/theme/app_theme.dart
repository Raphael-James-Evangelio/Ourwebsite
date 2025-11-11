import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = _buildLightTheme();

  static ThemeData _buildLightTheme() {
    final base = ThemeData.light();

    return base.copyWith(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFFB66D6D),
        secondary: Color(0xFF6D9D9D),
        tertiary: Color(0xFFF6D7D2),
        background: Color(0xFFFFF8F6),
        surface: Color(0xFFFFFFFF),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(0xFF2D1B21),
        onBackground: Color(0xFF2D1B21),
      ),
      scaffoldBackgroundColor: const Color(0xFFFFF8F6),
      textTheme: GoogleFonts.nunitoTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w600),
        displayMedium: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w600),
        displaySmall: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w600),
        headlineMedium: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w500),
        headlineSmall: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w500),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF2D1B21),
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF2D1B21),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: const Color(0xFFFAE6E2),
        labelStyle: GoogleFonts.nunito(
          fontWeight: FontWeight.w600,
          color: const Color(0xFF7D4E57),
        ),
      ),
    );
  }
}

