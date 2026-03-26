import 'package:flutter/material.dart';
import '../theme/app_theme_palette.dart';

class MediaErrorView extends StatelessWidget {
  const MediaErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemePalette palette = AppThemePalette.of(context);
    return ColoredBox(
      color: palette.elevatedSurface,
      child: Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: palette.textSecondary,
        ),
      ),
    );
  }
}
