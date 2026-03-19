import 'package:dartz/dartz.dart';

extension EitherX<L, R> on Either<L, R> {
  T when<T>({
    required T Function(L value) left,
    required T Function(R value) right,
  }) {
    return fold(left, right);
  }
}
