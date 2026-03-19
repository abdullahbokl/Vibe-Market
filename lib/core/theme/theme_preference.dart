import 'package:flutter/material.dart';

enum ThemePreference { system, light, dark }

extension ThemePreferenceX on ThemePreference {
  String get storageValue => name;

  String get label => switch (this) {
    ThemePreference.system => 'System',
    ThemePreference.light => 'Light',
    ThemePreference.dark => 'Dark',
  };

  ThemeMode get themeMode => switch (this) {
    ThemePreference.system => ThemeMode.system,
    ThemePreference.light => ThemeMode.light,
    ThemePreference.dark => ThemeMode.dark,
  };

  static ThemePreference fromStorage(String? value) {
    for (final ThemePreference preference in ThemePreference.values) {
      if (preference.storageValue == value) {
        return preference;
      }
    }
    return ThemePreference.system;
  }
}
