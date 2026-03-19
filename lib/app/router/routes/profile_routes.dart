part of '../app_router.dart';

@TypedGoRoute<WishlistRouteData>(path: '/wishlist')
class WishlistRouteData extends GoRouteData with $WishlistRouteData {
  const WishlistRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return WishlistPage(
      onOpenProduct: (String productId) => ProductRouteData(productId).push(context),
      onOpenSignIn: () => const SignInRouteData().push(context),
    );
  }
}

class ProfileRouteData extends GoRouteData with $ProfileRouteData {
  const ProfileRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProfilePage(
      onOpenSignIn: () => const SignInRouteData().push(context),
      onOpenWishlist: () => const WishlistRouteData().push(context),
      onOpenOrders: () => const OrdersRouteData().push(context),
    );
  }
}
