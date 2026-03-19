import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/bootstrap/presentation/pages/splash_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/checkout/presentation/pages/checkout_page.dart';
import '../../features/feed/presentation/pages/feed_page.dart';
import '../../features/orders/presentation/pages/orders_page.dart';
import '../../features/product/presentation/pages/product_detail_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/wishlist/presentation/pages/wishlist_page.dart';
import 'app_shell_scaffold.dart';

part 'app_router.g.dart';
part 'routes/app_shell_routes.dart';
part 'routes/auth_routes.dart';
part 'routes/commerce_routes.dart';
part 'routes/profile_routes.dart';

GoRouter createRouter() {
  return GoRouter(
    routes: $appRoutes,
    initialLocation: const SplashRouteData().location,
  );
}
