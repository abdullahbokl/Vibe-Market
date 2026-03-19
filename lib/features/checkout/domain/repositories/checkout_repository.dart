import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../auth/domain/entities/auth_session.dart';
import '../../../cart/domain/entities/cart_entities.dart';
import '../entities/checkout_entities.dart';

abstract class CheckoutRepository {
  Future<Either<Failure, CheckoutQuote>> buildQuote(CartSnapshot cart);

  Future<Either<Failure, CheckoutConfirmation>> createCheckoutIntent({
    required CartSnapshot cart,
    required AuthSession session,
  });
}
