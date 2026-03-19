part of 'feed_bloc.dart';

enum FeedStatus { initial, loading, success, failure }

class FeedState extends Equatable {
  const FeedState({required this.status, required this.items, this.failure});

  factory FeedState.initial() {
    return const FeedState(
      status: FeedStatus.initial,
      items: <ProductSummary>[],
    );
  }

  final FeedStatus status;
  final List<ProductSummary> items;
  final Failure? failure;

  FeedState copyWith({
    FeedStatus? status,
    List<ProductSummary>? items,
    Failure? failure,
  }) {
    return FeedState(
      status: status ?? this.status,
      items: items ?? this.items,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => <Object?>[status, items, failure];
}
