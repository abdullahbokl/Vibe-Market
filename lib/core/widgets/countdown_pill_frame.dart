import 'package:flutter/material.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme_palette.dart';

class CountdownPillFrame extends StatelessWidget {
  const CountdownPillFrame({
    required this.label,
    super.key,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    final AppThemePalette palette = AppThemePalette.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.elevatedSurface,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: palette.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        child: Text(label),
      ),
    );
  }
}
