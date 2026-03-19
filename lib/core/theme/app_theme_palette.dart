import 'package:flutter/material.dart';

@immutable
class AppThemePalette extends ThemeExtension<AppThemePalette> {
  const AppThemePalette({
    required this.background,
    required this.surface,
    required this.elevatedSurface,
    required this.accent,
    required this.accentSoft,
    required this.textPrimary,
    required this.textSecondary,
    required this.success,
    required this.danger,
    required this.outline,
  });

  const AppThemePalette.dark()
    : this(
        background: const Color(0xFF050505),
        surface: const Color(0xFF121212),
        elevatedSurface: const Color(0xFF1B1B1B),
        accent: const Color(0xFFD8B35C),
        accentSoft: const Color(0xFF8E7843),
        textPrimary: const Color(0xFFF8F4EA),
        textSecondary: const Color(0xFFB8B0A0),
        success: const Color(0xFF43A26B),
        danger: const Color(0xFFD85C5C),
        outline: const Color(0xFF2A2A2A),
      );

  const AppThemePalette.light()
    : this(
        background: const Color(0xFFF6F0E6),
        surface: const Color(0xFFFFFBF5),
        elevatedSurface: const Color(0xFFF0E7D8),
        accent: const Color(0xFFC89C42),
        accentSoft: const Color(0xFF9D7530),
        textPrimary: const Color(0xFF1F1810),
        textSecondary: const Color(0xFF6C5A45),
        success: const Color(0xFF3E8C5A),
        danger: const Color(0xFFC45858),
        outline: const Color(0xFFD8C8B0),
      );

  final Color background;
  final Color surface;
  final Color elevatedSurface;
  final Color accent;
  final Color accentSoft;
  final Color textPrimary;
  final Color textSecondary;
  final Color success;
  final Color danger;
  final Color outline;

  static AppThemePalette of(BuildContext context) {
    return Theme.of(context).extension<AppThemePalette>() ??
        const AppThemePalette.dark();
  }

  @override
  AppThemePalette copyWith({
    Color? background,
    Color? surface,
    Color? elevatedSurface,
    Color? accent,
    Color? accentSoft,
    Color? textPrimary,
    Color? textSecondary,
    Color? success,
    Color? danger,
    Color? outline,
  }) {
    return AppThemePalette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      elevatedSurface: elevatedSurface ?? this.elevatedSurface,
      accent: accent ?? this.accent,
      accentSoft: accentSoft ?? this.accentSoft,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      success: success ?? this.success,
      danger: danger ?? this.danger,
      outline: outline ?? this.outline,
    );
  }

  @override
  AppThemePalette lerp(ThemeExtension<AppThemePalette>? other, double t) {
    return this;
  }
}
