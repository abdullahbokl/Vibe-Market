import 'package:flutter/material.dart';

import 'app_theme_components.dart';
import 'app_theme_palette.dart';
import 'app_theme_text.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData dark() {
    return _buildTheme(
      brightness: Brightness.dark,
      palette: const AppThemePalette.dark(),
    );
  }

  static ThemeData light() {
    return _buildTheme(
      brightness: Brightness.light,
      palette: const AppThemePalette.light(),
    );
  }

  static ThemeData _buildTheme({
    required Brightness brightness,
    required AppThemePalette palette,
  }) {
    final ThemeData base = createBaseTheme(
      brightness: brightness,
      palette: palette,
    );
    final TextTheme textTheme = createAppTextTheme(base.textTheme, palette);
    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: buildAppBarTheme(textTheme, brightness),
      cardTheme: buildCardTheme(palette),
      navigationBarTheme: buildNavigationBarTheme(textTheme, palette),
      chipTheme: buildChipTheme(base, palette),
      inputDecorationTheme: buildInputDecorationTheme(palette),
      elevatedButtonTheme: buildElevatedButtonTheme(palette),
      outlinedButtonTheme: buildOutlinedButtonTheme(palette),
      extensions: <ThemeExtension<dynamic>>[palette],
    );
  }
}
