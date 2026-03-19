import 'package:flutter_test/flutter_test.dart';
import 'package:vibemarket/core/theme/theme_preference.dart';

void main() {
  test('theme preference serializes and falls back to system', () {
    expect(ThemePreference.system.storageValue, 'system');
    expect(ThemePreference.light.storageValue, 'light');
    expect(ThemePreference.dark.storageValue, 'dark');
    expect(
      ThemePreferenceX.fromStorage(ThemePreference.dark.storageValue),
      ThemePreference.dark,
    );
    expect(ThemePreferenceX.fromStorage('unknown'), ThemePreference.system);
    expect(ThemePreferenceX.fromStorage(null), ThemePreference.system);
  });
}
