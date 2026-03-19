import 'package:equatable/equatable.dart';

class CheckoutQuote extends Equatable {
  const CheckoutQuote({
    required this.subtotalCents,
    required this.shippingCents,
    required this.totalCents,
    required this.currencyCode,
    required this.canCheckout,
  });

  final int subtotalCents;
  final int shippingCents;
  final int totalCents;
  final String currencyCode;
  final bool canCheckout;

  @override
  List<Object?> get props => <Object?>[
    subtotalCents,
    shippingCents,
    totalCents,
    currencyCode,
    canCheckout,
  ];
}

class CheckoutConfirmation extends Equatable {
  const CheckoutConfirmation({
    required this.orderId,
    required this.idempotencyKey,
    required this.clientSecret,
    required this.isDemo,
  });

  final String orderId;
  final String idempotencyKey;
  final String clientSecret;
  final bool isDemo;

  @override
  List<Object?> get props => <Object?>[
    orderId,
    idempotencyKey,
    clientSecret,
    isDemo,
  ];
}
