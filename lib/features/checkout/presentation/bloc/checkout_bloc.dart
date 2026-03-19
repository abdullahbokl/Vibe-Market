import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../auth/domain/entities/auth_session.dart';
import '../../../cart/domain/entities/cart_entities.dart';
import '../../domain/entities/checkout_entities.dart';
import '../../domain/repositories/checkout_repository.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc(this._repository) : super(CheckoutState.initial()) {
    on<CheckoutStarted>(_onStarted);
    on<CheckoutSubmitted>(_onSubmitted);
  }

  final CheckoutRepository _repository;

  Future<void> _onStarted(
    CheckoutStarted event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(state.copyWith(status: CheckoutStatus.loading, failure: null));
    final result = await _repository.buildQuote(event.cart);
    result.fold(
      (Failure failure) => emit(
        state.copyWith(status: CheckoutStatus.failure, failure: failure),
      ),
      (CheckoutQuote quote) => emit(
        state.copyWith(
          status: CheckoutStatus.ready,
          quote: quote,
          failure: null,
        ),
      ),
    );
  }

  Future<void> _onSubmitted(
    CheckoutSubmitted event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(state.copyWith(status: CheckoutStatus.submitting, failure: null));
    final result = await _repository.createCheckoutIntent(
      cart: event.cart,
      session: event.session,
    );
    result.fold(
      (Failure failure) => emit(
        state.copyWith(status: CheckoutStatus.failure, failure: failure),
      ),
      (CheckoutConfirmation confirmation) => emit(
        state.copyWith(
          status: CheckoutStatus.success,
          confirmation: confirmation,
          failure: null,
        ),
      ),
    );
  }
}
