import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  }) : _gateway = gateway,
       _environment = environment,
       _orderRepository = orderRepository;

  final SupabaseGateway _gateway;
  final AppEnvironment _environment;
  final PersistentOrderRepository _orderRepository;

  @override
  Future<Either<Failure, CheckoutQuote>> buildQuote(CartSnapshot cart) async {
    final int shippingCents = cart.subtotalCents >= 20000 ? 0 : 900;
    return right(
      CheckoutQuote(
        subtotalCents: cart.subtotalCents,
        shippingCents: shippingCents,
        totalCents: cart.subtotalCents + shippingCents,
        currencyCode: 'USD',
        canCheckout: cart.items.isNotEmpty,
      ),
    );
  }

  @override
  Future<Either<Failure, CheckoutConfirmation>> createCheckoutIntent({
    required CartSnapshot cart,
    required AuthSession session,
  }) async {
    if (!session.isAuthenticated) {
      return const Left<Failure, CheckoutConfirmation>(
        Failure.validation('Sign in before starting checkout.'),
      );
    }
    if (cart.items.isEmpty) {
      return const Left<Failure, CheckoutConfirmation>(
        Failure.validation('Your cart is empty.'),
      );
    }

    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    final String productId = cart.items.first.product.id;
    final String userId = session.user?.id ?? 'guest';
    final String idempotencyKey = '$userId-$productId-$timestamp';

    final SupabaseClient? client = _gateway.client;
    if (client != null) {
      try {
        final FunctionResponse response = await client.functions.invoke(
          'create-checkout-intent',
          body: <String, dynamic>{
            'user_id': userId,
            'product_id': productId,
            'idempotency_key': idempotencyKey,
            'items': cart.items
                .map(
                  (CartItem item) => <String, dynamic>{
                    'product_id': item.product.id,
                    'quantity': item.quantity,
                  },
                )
                .toList(),
          },
        );
        final Object? responseData = response.data;
        if (responseData is Map<String, dynamic>) {
          final String orderId =
              responseData['order_id'] as String? ?? 'order_$timestamp';
          final String clientSecret =
              responseData['client_secret'] as String? ?? 'demo_client_secret';
          await _persistOrder(cart, orderId, status: 'pending_payment');
          return right(
            CheckoutConfirmation(
              orderId: orderId,
              idempotencyKey: idempotencyKey,
              clientSecret: clientSecret,
              isDemo: false,
            ),
          );
        }
      } catch (_) {
        if (!_environment.isDemoMode) {
          return const Left<Failure, CheckoutConfirmation>(
            Failure.payment('Checkout intent could not be created right now.'),
          );
        }
      }
    }

    final String orderId = 'demo_order_$timestamp';
    await _persistOrder(cart, orderId, status: 'paid');
    return right(
      CheckoutConfirmation(
        orderId: orderId,
        idempotencyKey: idempotencyKey,
        clientSecret: 'demo_client_secret_$timestamp',
        isDemo: true,
      ),
    );
  }

  Future<void> _persistOrder(
    CartSnapshot cart,
    String orderId, {
    required String status,
  }) {
    return _orderRepository.appendOrder(
      OrderSummary(
        id: orderId,
        title: cart.items.length == 1
            ? cart.items.first.product.title
            : '${cart.items.first.product.title} +${cart.items.length - 1}',
        amountCents: cart.subtotalCents,
        currencyCode: cart.items.first.product.currencyCode,
        status: status,
        createdAt: DateTime.now(),
      ),
    );
  }
}
