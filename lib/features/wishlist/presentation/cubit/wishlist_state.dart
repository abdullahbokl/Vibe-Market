part of 'wishlist_cubit.dart';

class WishlistState extends Equatable {
  const WishlistState({required this.ids, required this.isBusy, this.failure});

  factory WishlistState.initial() {
    return const WishlistState(ids: <String>{}, isBusy: false);
  }

  final Set<String> ids;
  final bool isBusy;
  final Failure? failure;

  WishlistState copyWith({Set<String>? ids, bool? isBusy, Failure? failure}) {
    return WishlistState(
      ids: ids ?? this.ids,
      isBusy: isBusy ?? this.isBusy,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => <Object?>[ids, isBusy, failure];
}
