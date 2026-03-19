part of 'feed_bloc.dart';

sealed class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class FeedRequested extends FeedEvent {
  const FeedRequested();
}

class FeedRefreshed extends FeedEvent {
  const FeedRefreshed();
}
