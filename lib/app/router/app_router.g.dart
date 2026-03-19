// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $splashRouteData,
  $signInRouteData,
  $productRouteData,
  $wishlistRouteData,
  $checkoutRouteData,
  $ordersRouteData,
  $vibeShellRouteData,
];

RouteBase get $splashRouteData =>
    GoRouteData.$route(path: '/splash', factory: $SplashRouteData._fromState);

mixin $SplashRouteData on GoRouteData {
  static SplashRouteData _fromState(GoRouterState state) =>
      const SplashRouteData();

  @override
  String get location => GoRouteData.$location('/splash');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $signInRouteData => GoRouteData.$route(
  path: '/auth/sign-in',
  factory: $SignInRouteData._fromState,
);

mixin $SignInRouteData on GoRouteData {
  static SignInRouteData _fromState(GoRouterState state) =>
      const SignInRouteData();

  @override
  String get location => GoRouteData.$location('/auth/sign-in');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $productRouteData => GoRouteData.$route(
  path: '/product/:productId',
  factory: $ProductRouteData._fromState,
);

mixin $ProductRouteData on GoRouteData {
  static ProductRouteData _fromState(GoRouterState state) =>
      ProductRouteData(state.pathParameters['productId']!);

  ProductRouteData get _self => this as ProductRouteData;

  @override
  String get location =>
      GoRouteData.$location('/product/${Uri.encodeComponent(_self.productId)}');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $wishlistRouteData => GoRouteData.$route(
  path: '/wishlist',
  factory: $WishlistRouteData._fromState,
);

mixin $WishlistRouteData on GoRouteData {
  static WishlistRouteData _fromState(GoRouterState state) =>
      const WishlistRouteData();

  @override
  String get location => GoRouteData.$location('/wishlist');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $checkoutRouteData => GoRouteData.$route(
  path: '/checkout',
  factory: $CheckoutRouteData._fromState,
);

mixin $CheckoutRouteData on GoRouteData {
  static CheckoutRouteData _fromState(GoRouterState state) =>
      const CheckoutRouteData();

  @override
  String get location => GoRouteData.$location('/checkout');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $ordersRouteData =>
    GoRouteData.$route(path: '/orders', factory: $OrdersRouteData._fromState);

mixin $OrdersRouteData on GoRouteData {
  static OrdersRouteData _fromState(GoRouterState state) =>
      const OrdersRouteData();

  @override
  String get location => GoRouteData.$location('/orders');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $vibeShellRouteData => StatefulShellRouteData.$route(
  navigatorContainerBuilder: VibeShellRouteData.$navigatorContainerBuilder,
  factory: $VibeShellRouteDataExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(path: '/feed', factory: $FeedRouteData._fromState),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/search',
          factory: $SearchRouteData._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(path: '/cart', factory: $CartRouteData._fromState),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/profile',
          factory: $ProfileRouteData._fromState,
        ),
      ],
    ),
  ],
);

extension $VibeShellRouteDataExtension on VibeShellRouteData {
  static VibeShellRouteData _fromState(GoRouterState state) =>
      const VibeShellRouteData();
}

mixin $FeedRouteData on GoRouteData {
  static FeedRouteData _fromState(GoRouterState state) => const FeedRouteData();

  @override
  String get location => GoRouteData.$location('/feed');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SearchRouteData on GoRouteData {
  static SearchRouteData _fromState(GoRouterState state) =>
      const SearchRouteData();

  @override
  String get location => GoRouteData.$location('/search');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $CartRouteData on GoRouteData {
  static CartRouteData _fromState(GoRouterState state) => const CartRouteData();

  @override
  String get location => GoRouteData.$location('/cart');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ProfileRouteData on GoRouteData {
  static ProfileRouteData _fromState(GoRouterState state) =>
      const ProfileRouteData();

  @override
  String get location => GoRouteData.$location('/profile');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
