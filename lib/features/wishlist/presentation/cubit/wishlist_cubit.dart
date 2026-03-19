import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../domain/repositories/wishlist_repository.dart';

part 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  WishlistCubit(this._repository) : super(WishlistState.initial());

  final WishlistRepository _repository;

  Future<void> load() async {
    final result = await _repository.loadWishlistIds();
    result.fold(
      (Failure failure) => emit(state.copyWith(failure: failure)),
      (Set<String> ids) => emit(state.copyWith(ids: ids, failure: null)),
    );
  }

  Future<void> toggle({
    required String productId,
    required String userScope,
  }) async {
    emit(state.copyWith(isBusy: true, failure: null));
    final result = await _repository.toggleWishlist(
      productId: productId,
      userScope: userScope,
    );
    result.fold(
      (Failure failure) =>
          emit(state.copyWith(isBusy: false, failure: failure)),
      (Set<String> ids) =>
          emit(state.copyWith(isBusy: false, ids: ids, failure: null)),
    );
  }

  void clear() {
    emit(WishlistState.initial());
  }
}
