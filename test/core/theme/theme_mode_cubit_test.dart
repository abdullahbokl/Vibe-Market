import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibemarket/core/theme/theme_mode_cubit.dart';
import 'package:vibemarket/core/theme/theme_mode_state.dart';
import 'package:vibemarket/core/theme/theme_preference.dart';
import 'package:vibemarket/core/theme/theme_preference_repository.dart';

class _FakeThemePreferenceRepository implements ThemePreferenceRepository {
  ThemePreference storedPreference;

  _FakeThemePreferenceRepository(this.storedPreference);

  @override
  Future<ThemePreference> loadPreference() async => storedPreference;

  @override
  Future<void> savePreference(ThemePreference preference) async {
    storedPreference = preference;
  }
}

void main() {
  blocTest<ThemeModeCubit, ThemeModeState>(
    'loads persisted preference and updates theme mode state',
    build: () => ThemeModeCubit(
      _FakeThemePreferenceRepository(ThemePreference.dark),
    ),
    act: (ThemeModeCubit cubit) => cubit.loadPreference(),
    expect: () => const <ThemeModeState>[
      ThemeModeState(preference: ThemePreference.dark),
    ],
  );

  blocTest<ThemeModeCubit, ThemeModeState>(
    'saves a new theme preference immediately',
    build: () => ThemeModeCubit(
      _FakeThemePreferenceRepository(ThemePreference.system),
    ),
    act: (ThemeModeCubit cubit) => cubit.setPreference(ThemePreference.light),
    expect: () => const <ThemeModeState>[
      ThemeModeState(preference: ThemePreference.light),
    ],
  );
}
