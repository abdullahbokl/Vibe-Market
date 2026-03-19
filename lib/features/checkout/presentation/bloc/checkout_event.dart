part of 'checkout_bloc.dart';

sealed class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class CheckoutStarted extends CheckoutEvent {
  const CheckoutStarted(this.cart);

  final CartSnapshot cart;

  @override
  List<Object?> get props => <Object?>[cart];
}

class CheckoutSubmitted extends CheckoutEvent {
  const CheckoutSubmitted({required this.cart, required this.session});

  final CartSnapshot cart;
  final AuthSession session;

  @override
  List<Object?> get props => <Object?>[cart, session];
}
