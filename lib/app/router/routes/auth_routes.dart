part of '../app_router.dart';

@TypedGoRoute<SplashRouteData>(path: '/splash')
class SplashRouteData extends GoRouteData with $SplashRouteData {
  const SplashRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SplashPage(onReady: () => const FeedRouteData().go(context));
  }
}

@TypedGoRoute<SignInRouteData>(path: '/auth/sign-in')
class SignInRouteData extends GoRouteData with $SignInRouteData {
  const SignInRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return SignInPage(onAuthenticated: () => const FeedRouteData().go(context));
  }
}
