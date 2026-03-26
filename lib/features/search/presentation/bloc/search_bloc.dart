import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core/error/failure.dart';
import '../../../product/domain/entities/product_entities.dart';
import '../../domain/usecases/browse_products.dart';
import '../../domain/usecases/search_products.dart';

part 'search_bloc_handlers.dart';
part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc(this._searchProducts, this._browseProducts)
    : super(SearchState.initial()) {
    on<SearchStarted>(_onSearchStarted);
    on<SearchCleared>(_onSearchCleared);
    on<SearchNextPageRequested>(
      _onSearchNextPageRequested,
      transformer: droppable(),
    );
    on<SearchQueryChanged>(
      _onSearchQueryChanged,
      transformer: _debounceRestartable<SearchQueryChanged>(
        const Duration(milliseconds: 350),
      ),
    );
  }

  static const int pageSize = 16;

  final SearchProducts _searchProducts;
  final BrowseProducts _browseProducts;
}
