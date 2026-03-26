import 'package:dartz/dartz.dart';
import '../../../../core/config/app_environment.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/services/supabase_gateway.dart';
import '../../../auth/domain/entities/auth_session.dart';
import '../../../cart/domain/entities/cart_entities.dart';
import '../../../orders/data/repositories/persistent_order_repository.dart';
import '../../../orders/domain/entities/order_entities.dart';
import '../../domain/entities/checkout_entities.dart';
import '../../domain/repositories/checkout_repository.dart';

class HybridCheckoutRepository implements CheckoutRepository {
  HybridCheckoutRepository({
    required SupabaseGateway gateway,
    required AppEnvironment environment,
    required PersistentOrderRepository orderRepository,
  }) : _gateway = gateway, _environment = environment, _orderRepository = orderRepository;

  final SupabaseGateway _gateway;
  final AppEnvironment _environment;
  final PersistentOrderRepository _orderRepository;

  @override
  Future<Either<Failure, CheckoutQuote>> buildQuote(CartSnapshot cart) async {
    final shipping = cart.subtotalCents >= 20000 ? 0 : 900;
    return right(CheckoutQuote(
      subtotalCents: cart.subtotalCents, shippingCents: shipping,
      totalCents: cart.subtotalCents + shipping, currencyCode: 'USD',
      canCheckout: cart.items.isNotEmpty,
    ));
  }

  @override
  Future<Either<Failure, CheckoutConfirmation>> createCheckoutIntent({
    required CartSnapshot cart, required AuthSession session,
  }) async {
    if (!session.isAuthenticated) return left(const Failure.validation('Sign in first.'));
    if (cart.items.isEmpty) return left(const Failure.validation('Cart is empty.'));

    final ts = DateTime.now().millisecondsSinceEpoch;
    final pid = cart.items.first.product.id;
    final uid = session.user?.id ?? 'guest';
    final ikey = '$uid-$pid-$ts';
    final client = _gateway.client;

    if (client != null) {
      try {
        final res = await client.functions.invoke('create-checkout-intent', body: {
          'user_id': uid, 'product_id': pid, 'idempotency_key': ikey,
          'items': cart.items.map((it) => {'product_id': it.product.id, 'quantity': it.quantity}).toList(),
        });
        final data = res.data;
        if (data is Map<String, dynamic>) {
          final oid = data['order_id'] as String? ?? 'order_$ts';
          await _persistOrder(cart, oid, 'pending_payment');
          return right(CheckoutConfirmation(orderId: oid, idempotencyKey: ikey, clientSecret: data['client_secret'] as String? ?? 'demo', isDemo: false));
        }
      } catch (_) {
        if (!_environment.isDemoMode) return left(const Failure.payment('Checkout failed.'));
      }
    }

    final oid = 'demo_order_$ts';
    await _persistOrder(cart, oid, 'paid');
    return right(CheckoutConfirmation(orderId: oid, idempotencyKey: ikey, clientSecret: 'demo_$ts', isDemo: true));
  }

  Future<void> _persistOrder(CartSnapshot cart, String oid, String status) {
    return _orderRepository.appendOrder(OrderSummary(
      id: oid, status: status, createdAt: DateTime.now(), amountCents: cart.subtotalCents,
      currencyCode: cart.items.first.product.currencyCode,
      title: cart.items.length == 1 ? cart.items.first.product.title : '${cart.items.first.product.title} +${cart.items.length - 1}',
    ));
  }
}
