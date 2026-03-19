part of 'checkout_bloc.dart';

enum CheckoutStatus { initial, loading, ready, submitting, success, failure }

class CheckoutState extends Equatable {
  const CheckoutState({
    required this.status,
    this.quote,
    this.confirmation,
    this.failure,
  });

  factory CheckoutState.initial() {
    return const CheckoutState(status: CheckoutStatus.initial);
  }

  final CheckoutStatus status;
  final CheckoutQuote? quote;
  final CheckoutConfirmation? confirmation;
  final Failure? failure;

  CheckoutState copyWith({
    CheckoutStatus? status,
    CheckoutQuote? quote,
    CheckoutConfirmation? confirmation,
    Failure? failure,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      quote: quote ?? this.quote,
      confirmation: confirmation ?? this.confirmation,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => <Object?>[status, quote, confirmation, failure];
}
