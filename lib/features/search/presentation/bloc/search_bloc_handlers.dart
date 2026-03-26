part of 'search_bloc.dart';

EventTransformer<T> _debounceRestartable<T>(Duration duration) =>
    (events, mapper) => restartable<T>().call(events.debounceTime(duration), mapper);

extension _SearchBlocHandlers on SearchBloc {
  Future<void> _onSearchStarted(SearchStarted event, Emitter<SearchState> emit) async {
    if (state.query.isEmpty && state.results.isEmpty) await _loadBrowsePage(emit, reset: true);
  }

  Future<void> _onSearchCleared(SearchCleared event, Emitter<SearchState> emit) async => _loadBrowsePage(emit, reset: true);

  Future<void> _onSearchNextPageRequested(SearchNextPageRequested event, Emitter<SearchState> emit) async {
    if (state.query.isEmpty && state.status != SearchStatus.loading && !state.isPaginating && !state.hasReachedEnd) {
      await _loadBrowsePage(emit, reset: false);
    }
  }

  Future<void> _onSearchQueryChanged(SearchQueryChanged event, Emitter<SearchState> emit) async {
    final q = event.query.trim();
    if (q.isEmpty) return _loadBrowsePage(emit, reset: true);
    emit(state.copyWith(status: SearchStatus.loading, query: q, results: [], failure: null, hasReachedEnd: true, isPaginating: false));
    (await _searchProducts(q)).fold(
      (f) => emit(state.copyWith(status: SearchStatus.failure, failure: f, hasReachedEnd: true, isPaginating: false)),
      (items) => emit(state.copyWith(status: items.isEmpty ? SearchStatus.empty : SearchStatus.success, results: items, query: q, hasReachedEnd: true)),
    );
  }

  Future<void> _loadBrowsePage(Emitter<SearchState> emit, {required bool reset}) async {
    final offset = reset ? 0 : state.results.length;
    emit(state.copyWith(status: reset ? SearchStatus.loading : SearchStatus.success, query: '', results: reset ? [] : state.results, hasReachedEnd: reset ? false : state.hasReachedEnd, isPaginating: !reset));
    (await _browseProducts(offset: offset, limit: SearchBloc.pageSize)).fold(
      (f) => emit(state.copyWith(status: SearchStatus.failure, failure: f, isPaginating: false)),
      (items) {
        final merged = reset ? items : [...state.results, ...items];
        emit(state.copyWith(status: merged.isEmpty ? SearchStatus.empty : SearchStatus.success, results: merged, hasReachedEnd: items.length < SearchBloc.pageSize, isPaginating: false));
      },
    );
  }
}
