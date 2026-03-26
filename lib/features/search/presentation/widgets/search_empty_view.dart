import 'package:flutter/material.dart';
import '../../../../core/widgets/empty_state_view.dart';

class SearchEmptyView extends StatelessWidget {
  const SearchEmptyView({
    required this.query,
    super.key,
  });

  final String query;

  @override
  Widget build(BuildContext context) {
    return EmptyStateView(
      title: query.isEmpty ? 'Catalog is still getting stocked' : 'No match yet',
      message: query.isEmpty
          ? 'Products will appear here automatically as the browse feed loads.'
          : 'Try broader language like outerwear, collectors, or flash capsule.',
    );
  }
}
