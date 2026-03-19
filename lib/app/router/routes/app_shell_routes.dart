part of '../app_router.dart';

@TypedStatefulShellRoute<VibeShellRouteData>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    TypedStatefulShellBranch<FeedBranchData>(
      routes: <TypedRoute<RouteData>>[TypedGoRoute<FeedRouteData>(path: '/feed')],
    ),
    TypedStatefulShellBranch<SearchBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<SearchRouteData>(path: '/search'),
      ],
    ),
    TypedStatefulShellBranch<CartBranchData>(
      routes: <TypedRoute<RouteData>>[TypedGoRoute<CartRouteData>(path: '/cart')],
    ),
    TypedStatefulShellBranch<ProfileBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<ProfileRouteData>(path: '/profile'),
      ],
    ),
  ],
)
class VibeShellRouteData extends StatefulShellRouteData {
  const VibeShellRouteData();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return navigationShell;
  }

  static Widget $navigatorContainerBuilder(
    BuildContext context,
    StatefulNavigationShell navigationShell,
    List<Widget> children,
  ) {
    return AppShellScaffold(
      navigationShell: navigationShell,
      children: children,
    );
  }
}

class FeedBranchData extends StatefulShellBranchData {
  const FeedBranchData();
}

class SearchBranchData extends StatefulShellBranchData {
  const SearchBranchData();
}

class CartBranchData extends StatefulShellBranchData {
  const CartBranchData();
}

class ProfileBranchData extends StatefulShellBranchData {
  const ProfileBranchData();
}

class FeedRouteData extends GoRouteData with $FeedRouteData {
  const FeedRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FeedPage(
      onOpenProduct: (String productId) => ProductRouteData(productId).push(context),
      onOpenSignIn: () => const SignInRouteData().push(context),
    );
  }
}

class SearchRouteData extends GoRouteData with $SearchRouteData {
  const SearchRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SearchPage(
      onOpenProduct: (String productId) => ProductRouteData(productId).push(context),
    );
  }
}

class CartRouteData extends GoRouteData with $CartRouteData {
  const CartRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CartPage(
      onOpenSignIn: () => const SignInRouteData().push(context),
      onOpenCheckout: () => const CheckoutRouteData().push(context),
    );
  }
}
