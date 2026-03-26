import 'package:flutter/material.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/widgets/failure_state_view.dart';
import '../bloc/search_bloc.dart';
import 'search_results_list.dart';

class SearchFailureView extends StatelessWidget {
  const SearchFailureView({
    required this.state,
    required this.scrollController,
    required this.onOpenProduct,
    super.key,
  });

  final SearchState state;
  final ScrollController scrollController;
  final void Function(String productId) onOpenProduct;

  @override
  Widget build(BuildContext context) {
    if (state.results.isNotEmpty) {
      return SearchResultsList(
        products: state.results,
        isPaginating: state.isPaginating,
        scrollController: scrollController,
        onOpenProduct: onOpenProduct,
      );
    }
    return FailureStateView(
      failure: state.failure ?? const Failure.unexpected('Search failed.'),
    );
  }
}
