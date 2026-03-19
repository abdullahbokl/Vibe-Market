import 'theme_preference.dart';

abstract interface class ThemePreferenceRepository {
  Future<ThemePreference> loadPreference();

  Future<void> savePreference(ThemePreference preference);
}
