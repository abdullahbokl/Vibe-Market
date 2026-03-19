part of '../app_router.dart';

@TypedGoRoute<ProductRouteData>(path: '/product/:productId')
class ProductRouteData extends GoRouteData with $ProductRouteData {
  const ProductRouteData(this.productId);

  final String productId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ProductDetailPage(
      productId: productId,
      onOpenSignIn: () => const SignInRouteData().push(context),
      onOpenCheckout: () => const CheckoutRouteData().push(context),
    );
  }
}

@TypedGoRoute<CheckoutRouteData>(path: '/checkout')
class CheckoutRouteData extends GoRouteData with $CheckoutRouteData {
  const CheckoutRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CheckoutPage(
      onOpenSignIn: () => const SignInRouteData().push(context),
      onOpenOrders: () => const OrdersRouteData().go(context),
    );
  }
}

@TypedGoRoute<OrdersRouteData>(path: '/orders')
class OrdersRouteData extends GoRouteData with $OrdersRouteData {
  const OrdersRouteData();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return OrdersPage(onOpenSignIn: () => const SignInRouteData().push(context));
  }
}
