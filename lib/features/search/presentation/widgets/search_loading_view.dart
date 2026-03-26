import 'package:flutter/material.dart';
import '../bloc/search_bloc.dart';
import 'search_results_list.dart';

class SearchLoadingView extends StatelessWidget {
  const SearchLoadingView({
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
    return const Center(child: CircularProgressIndicator());
  }
}
