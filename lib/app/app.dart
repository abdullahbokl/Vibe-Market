import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../core/performance/performance_trace.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/theme_mode_cubit.dart';
import '../core/theme/theme_mode_state.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../features/bootstrap/presentation/cubit/bootstrap_cubit.dart';
import '../features/cart/presentation/cubit/cart_cubit.dart';
import '../features/wishlist/presentation/cubit/wishlist_cubit.dart';
import '../core/services/snackbar_service.dart';
import 'di/service_locator.dart';

class VibeMarketApp extends StatefulWidget {
  const VibeMarketApp({super.key});

  @override
  State<VibeMarketApp> createState() => _VibeMarketAppState();
}

class _VibeMarketAppState extends State<VibeMarketApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PerformanceTrace.finish(
        'app.startup',
        label: 'App first frame painted',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<ThemeModeCubit>.value(value: locator<ThemeModeCubit>()),
        BlocProvider<AuthCubit>.value(value: locator<AuthCubit>()),
        BlocProvider<WishlistCubit>.value(value: locator<WishlistCubit>()),
        BlocProvider<CartCubit>.value(value: locator<CartCubit>()),
        BlocProvider<BootstrapCubit>.value(value: locator<BootstrapCubit>()),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listenWhen: (AuthState previous, AuthState current) =>
            previous.session != current.session,
        listener: (BuildContext context, AuthState state) {
          if (state.canAccessProtectedActions) {
            context.read<WishlistCubit>().load();
          } else {
            context.read<WishlistCubit>().clear();
          }
        },
        child: BlocBuilder<ThemeModeCubit, ThemeModeState>(
          builder: (BuildContext context, ThemeModeState state) {
            return MaterialApp.router(
              title: 'VibeMarket',
              debugShowCheckedModeBanner: false,
              scaffoldMessengerKey: locator<SnackbarService>().messengerKey,
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              themeMode: state.themeMode,
              routerConfig: locator<GoRouter>(),
            );
          },
        ),
      ),
    );
  }
}
