import 'package:flutter/material.dart';
import '../theme/app_theme_palette.dart';

class MediaPlaceholder extends StatelessWidget {
  const MediaPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final AppThemePalette palette = AppThemePalette.of(context);
    return ColoredBox(
      color: palette.elevatedSurface,
      child: const SizedBox.expand(),
    );
  }
}
