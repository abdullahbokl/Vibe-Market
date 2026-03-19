import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../core/config/app_environment.dart';
import '../core/performance/performance_trace.dart';
import '../core/services/connectivity_service.dart';
import '../core/services/supabase_gateway.dart';
import '../core/storage/app_cache_store.dart';
import '../core/storage/app_secure_storage.dart';
import '../core/theme/theme_mode_cubit.dart';
import '../features/cart/presentation/cubit/cart_cubit.dart';
import '../features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'app.dart';
import 'di/service_locator.dart';
import 'observers/vibe_bloc_observer.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  PerformanceTrace.start('app.startup');

  final AppEnvironment environment = AppEnvironment.fromDefines();
  await Hive.initFlutter();

  final AppCacheStore cacheStore = await AppCacheStore.open();
  final AppSecureStorage secureStorage = AppSecureStorage();
  final ConnectivityService connectivityService = ConnectivityService();
  final SupabaseGateway supabaseGateway = await SupabaseGateway.initialize(
    environment,
  );

  if (environment.isStripeConfigured) {
    Stripe.publishableKey = environment.stripePublishableKey;
    await Stripe.instance.applySettings();
  }

  Bloc.observer = const VibeBlocObserver();

  await configureDependencies(
    environment: environment,
    cacheStore: cacheStore,
    secureStorage: secureStorage,
    connectivityService: connectivityService,
    supabaseGateway: supabaseGateway,
  );

  await locator<ThemeModeCubit>().loadPreference();
  unawaited(locator<CartCubit>().loadCart());
  unawaited(locator<WishlistCubit>().load());

  runApp(const VibeMarketApp());
}
