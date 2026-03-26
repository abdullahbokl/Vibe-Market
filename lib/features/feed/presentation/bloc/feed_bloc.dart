import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../../product/domain/entities/product_entities.dart';
import '../../domain/usecases/get_featured_feed.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  FeedBloc(this._getFeaturedFeed) : super(FeedState.initial()) {
    on<FeedRequested>(_onFeedRequested, transformer: droppable());
    on<FeedRefreshed>(_onFeedRefreshed, transformer: restartable());
  }

  final GetFeaturedFeed _getFeaturedFeed;

  Future<void> _onFeedRequested(
    FeedRequested event,
    Emitter<FeedState> emit,
  ) async {
    if (state.status == FeedStatus.success) {
      return;
    }
    await _fetchFeed(emit);
  }

  Future<void> _onFeedRefreshed(
    FeedRefreshed event,
    Emitter<FeedState> emit,
  ) async {
    await _fetchFeed(emit);
  }

  Future<void> _fetchFeed(Emitter<FeedState> emit) async {
    emit(state.copyWith(status: FeedStatus.loading, failure: null));
    final result = await _getFeaturedFeed();
    result.fold(
      (Failure failure) =>
          emit(state.copyWith(status: FeedStatus.failure, failure: failure)),
      (List<ProductSummary> items) => emit(
        state.copyWith(status: FeedStatus.success, items: items, failure: null),
      ),
    );
  }
}
