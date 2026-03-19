import 'package:flutter/material.dart';

import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme_palette.dart';

class PriceBadge extends StatelessWidget {
  const PriceBadge({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final AppThemePalette palette = AppThemePalette.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.accent.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        child: Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(color: palette.accent),
        ),
      ),
    );
  }
}
