import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/theme_mode_cubit.dart';
import '../../../../core/theme/theme_mode_state.dart';
import '../../../../core/theme/theme_preference.dart';

class ProfileAppearanceSection extends StatelessWidget {
  const ProfileAppearanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: BlocBuilder<ThemeModeCubit, ThemeModeState>(
          builder: (BuildContext context, ThemeModeState state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Appearance', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Choose how VibeMarket looks on this device.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                SegmentedButton<ThemePreference>(
                  segments: ThemePreference.values
                      .map(
                        (ThemePreference preference) => ButtonSegment<ThemePreference>(
                          value: preference,
                          label: Text(preference.label),
                        ),
                      )
                      .toList(),
                  selected: <ThemePreference>{state.preference},
                  onSelectionChanged: (Set<ThemePreference> selection) {
                    if (selection.isEmpty) {
                      return;
                    }
                    context.read<ThemeModeCubit>().setPreference(
                      selection.first,
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
