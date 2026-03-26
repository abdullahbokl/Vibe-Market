import 'package:flutter/material.dart';
import '../../../product/domain/entities/product_entities.dart';
import 'search_result_row.dart';

class SearchResultsList extends StatelessWidget {
  const SearchResultsList({
    required this.products,
    required this.isPaginating,
    required this.scrollController,
    required this.onOpenProduct,
    super.key,
  });

  final List<ProductSummary> products;
  final bool isPaginating;
  final ScrollController scrollController;
  final void Function(String productId) onOpenProduct;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: scrollController,
      itemCount: products.length + (isPaginating ? 1 : 0),
      separatorBuilder: (_, ignoredIndex) => const Divider(height: 1),
      itemBuilder: (BuildContext context, int index) {
        if (index >= products.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return RepaintBoundary(
          child: SearchResultRow(
            product: products[index],
            onTap: () => onOpenProduct(products[index].id),
          ),
        );
      },
    );
  }
}
