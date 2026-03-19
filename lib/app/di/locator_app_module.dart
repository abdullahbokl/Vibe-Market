import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../core/config/app_environment.dart';
import '../../core/network/dio_factory.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/services/supabase_gateway.dart';
import '../../core/storage/app_cache_store.dart';
import '../../core/storage/app_secure_storage.dart';
import '../../core/theme/persistent_theme_preference_repository.dart';
import '../../core/theme/theme_preference_repository.dart';
import '../router/app_router.dart';

void registerAppModule(
  GetIt locator, {
  required AppEnvironment environment,
  required AppCacheStore cacheStore,
  required AppSecureStorage secureStorage,
  required ConnectivityService connectivityService,
  required SupabaseGateway supabaseGateway,
}) {
  locator.registerSingleton<AppEnvironment>(environment);
  locator.registerSingleton<AppCacheStore>(cacheStore);
  locator.registerSingleton<AppSecureStorage>(secureStorage);
  locator.registerSingleton<ConnectivityService>(connectivityService);
  locator.registerSingleton<SupabaseGateway>(supabaseGateway);
  locator.registerLazySingleton<ThemePreferenceRepository>(
    () => PersistentThemePreferenceRepository(locator()),
  );
  locator.registerSingleton<Dio>(DioFactory.create(environment));
  locator.registerLazySingleton<GoRouter>(createRouter);
}
