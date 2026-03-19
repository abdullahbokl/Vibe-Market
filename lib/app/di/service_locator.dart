import 'package:get_it/get_it.dart';

import '../../core/config/app_environment.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/services/supabase_gateway.dart';
import '../../core/storage/app_cache_store.dart';
import '../../core/storage/app_secure_storage.dart';
import 'locator_app_module.dart';
import 'locator_feature_module.dart';
import 'locator_state_module.dart';

final GetIt locator = GetIt.instance;

Future<void> configureDependencies({
  required AppEnvironment environment,
  required AppCacheStore cacheStore,
  required AppSecureStorage secureStorage,
  required ConnectivityService connectivityService,
  required SupabaseGateway supabaseGateway,
}) async {
  await locator.reset();
  registerAppModule(
    locator,
    environment: environment,
    cacheStore: cacheStore,
    secureStorage: secureStorage,
    connectivityService: connectivityService,
    supabaseGateway: supabaseGateway,
  );
  registerFeatureModule(locator);
  registerStateModule(locator);
}
