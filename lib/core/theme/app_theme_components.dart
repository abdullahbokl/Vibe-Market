import 'package:flutter/material.dart';

import 'app_system_ui.dart';
import 'app_theme_palette.dart';
import 'app_radius.dart';
import 'app_spacing.dart';

ThemeData createBaseTheme({
  required Brightness brightness,
  required AppThemePalette palette,
}) {
  final ColorScheme seedScheme = ColorScheme.fromSeed(
    brightness: brightness,
    seedColor: palette.accent,
  );
  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    scaffoldBackgroundColor: palette.background,
    colorScheme: seedScheme.copyWith(
      primary: palette.accent,
      secondary: palette.accentSoft,
      surface: palette.surface,
      onSurface: palette.textPrimary,
      error: palette.danger,
      outline: palette.outline,
    ),
  );
}

AppBarTheme buildAppBarTheme(
  TextTheme textTheme,
  Brightness brightness,
) => AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: textTheme.titleLarge,
      systemOverlayStyle: buildSystemUiOverlayStyle(brightness),
    );

CardThemeData buildCardTheme(AppThemePalette palette) => CardThemeData(
  color: palette.elevatedSurface,
  elevation: 0,
  margin: EdgeInsets.zero,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppRadius.lg),
    side: BorderSide(color: palette.outline),
  ),
);

NavigationBarThemeData buildNavigationBarTheme(
  TextTheme textTheme,
  AppThemePalette palette,
) {
  return NavigationBarThemeData(
    backgroundColor: palette.surface,
    indicatorColor: palette.accent.withValues(alpha: 0.15),
    labelTextStyle: WidgetStatePropertyAll<TextStyle?>(textTheme.labelLarge),
  );
}

ChipThemeData buildChipTheme(ThemeData base, AppThemePalette palette) =>
    base.chipTheme.copyWith(
      backgroundColor: palette.elevatedSurface,
      selectedColor: palette.accent.withValues(alpha: 0.2),
      side: BorderSide(color: palette.outline),
    );

InputDecorationTheme buildInputDecorationTheme(AppThemePalette palette) {
  final OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppRadius.md),
    borderSide: BorderSide(color: palette.outline),
);
  return InputDecorationTheme(
    filled: true,
    fillColor: palette.elevatedSurface,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.md,
    ),
    border: border,
    enabledBorder: border,
    focusedBorder: border.copyWith(
      borderSide: BorderSide(color: palette.accent),
    ),
  );
}

ElevatedButtonThemeData buildElevatedButtonTheme(AppThemePalette palette) =>
    ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: palette.accent,
    foregroundColor: palette.background,
    minimumSize: const Size.fromHeight(52),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
    ),
  ),
);

OutlinedButtonThemeData buildOutlinedButtonTheme(AppThemePalette palette) =>
    OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: palette.textPrimary,
        minimumSize: const Size.fromHeight(52),
        side: BorderSide(color: palette.outline),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
