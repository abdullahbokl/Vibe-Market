import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_theme_palette.dart';

TextTheme createAppTextTheme(TextTheme base, AppThemePalette palette) {
  return GoogleFonts.manropeTextTheme(base).copyWith(
    displaySmall: GoogleFonts.cormorantGaramond(
      fontSize: 42,
      fontWeight: FontWeight.w700,
      color: palette.textPrimary,
    ),
    headlineMedium: _manrope(24, FontWeight.w700, palette.textPrimary),
    titleLarge: _manrope(18, FontWeight.w700, palette.textPrimary),
    titleMedium: _manrope(16, FontWeight.w600, palette.textPrimary),
    bodyLarge: _manrope(16, FontWeight.w500, palette.textPrimary),
    bodyMedium: _manrope(14, FontWeight.w500, palette.textSecondary),
    labelLarge: _manrope(14, FontWeight.w700, palette.textPrimary),
  );
}

TextStyle _manrope(double size, FontWeight weight, Color color) {
  return GoogleFonts.manrope(
    fontSize: size,
    fontWeight: weight,
    color: color,
  );
}
