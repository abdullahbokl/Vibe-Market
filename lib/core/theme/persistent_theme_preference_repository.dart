import '../storage/app_cache_store.dart';
import 'theme_preference.dart';
import 'theme_preference_repository.dart';

class PersistentThemePreferenceRepository
    implements ThemePreferenceRepository {
  PersistentThemePreferenceRepository(this._cacheStore);

  static const String _cacheKey = 'appearance::theme_preference';

  final AppCacheStore _cacheStore;

  @override
  Future<ThemePreference> loadPreference() async {
    final String? storedValue = _cacheStore.readString(_cacheKey);
    return ThemePreferenceX.fromStorage(storedValue);
  }

  @override
  Future<void> savePreference(ThemePreference preference) {
    return _cacheStore.putString(_cacheKey, preference.storageValue);
  }
}
