import 'package:get_it/get_it.dart';

import '../../core/theme/theme_mode_cubit.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/bootstrap/presentation/cubit/bootstrap_cubit.dart';
import '../../features/cart/presentation/cubit/cart_cubit.dart';
import '../../features/checkout/presentation/bloc/checkout_bloc.dart';
import '../../features/feed/presentation/bloc/feed_bloc.dart';
import '../../features/orders/presentation/bloc/orders_bloc.dart';
import '../../features/product/presentation/bloc/product_drop_bloc.dart';
import '../../features/search/presentation/bloc/search_bloc.dart';
import '../../features/wishlist/presentation/cubit/wishlist_cubit.dart';

void registerStateModule(GetIt locator) {
  locator.registerLazySingleton<ThemeModeCubit>(() => ThemeModeCubit(locator()));
  locator.registerLazySingleton<AuthCubit>(() => AuthCubit(locator()));
  locator.registerLazySingleton<WishlistCubit>(() => WishlistCubit(locator()));
  locator.registerLazySingleton<CartCubit>(() => CartCubit(locator()));
  locator.registerLazySingleton<BootstrapCubit>(
    () => BootstrapCubit(
      connectivityService: locator(),
      environment: locator(),
      authCubit: locator(),
    ),
  );
  locator.registerFactory(() => FeedBloc(locator()));
  locator.registerFactory(() => SearchBloc(locator(), locator()));
  locator.registerFactory(
    () => ProductDropBloc(
      productRepository: locator(),
      reactionRepository: locator(),
    ),
  );
  locator.registerFactory(() => CheckoutBloc(locator()));
  locator.registerFactory(() => OrdersBloc(locator()));
}
