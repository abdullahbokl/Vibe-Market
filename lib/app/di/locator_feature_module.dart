import 'package:get_it/get_it.dart';

import '../../features/auth/data/repositories/supabase_auth_repository.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/continue_as_guest.dart';
import '../../features/auth/domain/usecases/load_current_session.dart';
import '../../features/cart/data/repositories/persistent_cart_repository.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/checkout/data/repositories/hybrid_checkout_repository.dart';
import '../../features/checkout/domain/repositories/checkout_repository.dart';
import '../../features/feed/data/repositories/hybrid_feed_repository.dart';
import '../../features/feed/domain/repositories/feed_repository.dart';
import '../../features/feed/domain/usecases/get_featured_feed.dart';
import '../../features/orders/data/repositories/persistent_order_repository.dart';
import '../../features/orders/domain/repositories/order_repository.dart';
import '../../features/product/data/datasources/catalog_seed_data_source.dart';
import '../../features/product/data/repositories/hybrid_product_repository.dart';
import '../../features/product/data/repositories/local_reaction_repository.dart';
import '../../features/product/domain/repositories/product_repository.dart';
import '../../features/product/domain/repositories/reaction_repository.dart';
import '../../features/search/data/repositories/hybrid_search_repository.dart';
import '../../features/search/data/datasources/search_cache_data_source.dart';
import '../../features/search/domain/repositories/search_repository.dart';
import '../../features/search/domain/usecases/browse_products.dart';
import '../../features/search/domain/usecases/search_products.dart';
import '../../features/wishlist/data/repositories/persistent_wishlist_repository.dart';
import '../../features/wishlist/domain/repositories/wishlist_repository.dart';

void registerFeatureModule(GetIt locator) {
  locator.registerLazySingleton<CatalogSeedDataSource>(CatalogSeedDataSource.new);
  locator.registerLazySingleton<AuthRepository>(() => SupabaseAuthRepository(
        gateway: locator(),
        secureStorage: locator(),
        environment: locator(),
      ));
  locator.registerLazySingleton<ProductRepository>(
    () => HybridProductRepository(dataSource: locator(), gateway: locator()),
  );
  locator.registerLazySingleton<ReactionRepository>(
    () => LocalReactionRepository(locator()),
  );
  locator.registerLazySingleton<FeedRepository>(
    () => HybridFeedRepository(dataSource: locator(), cacheStore: locator()),
  );
  locator.registerLazySingleton<SearchCacheDataSource>(
    () => SearchCacheDataSource(locator()),
  );
  locator.registerLazySingleton<SearchRepository>(() => HybridSearchRepository(
        dataSource: locator(),
        cacheDataSource: locator(),
        gateway: locator(),
      ));
  locator.registerLazySingleton<WishlistRepository>(
    () => PersistentWishlistRepository(locator()),
  );
  locator.registerLazySingleton<CartRepository>(
    () => PersistentCartRepository(locator()),
  );
  locator.registerLazySingleton<PersistentOrderRepository>(
    () => PersistentOrderRepository(locator()),
  );
  locator.registerLazySingleton<OrderRepository>(
    () => locator<PersistentOrderRepository>(),
  );
  locator.registerLazySingleton<CheckoutRepository>(() => HybridCheckoutRepository(
        gateway: locator(),
        environment: locator(),
        orderRepository: locator(),
      ));
  locator.registerLazySingleton(() => LoadCurrentSession(locator()));
  locator.registerLazySingleton(() => ContinueAsGuest(locator()));
  locator.registerLazySingleton(() => GetFeaturedFeed(locator()));
  locator.registerLazySingleton(() => SearchProducts(locator()));
  locator.registerLazySingleton(() => BrowseProducts(locator()));
}
