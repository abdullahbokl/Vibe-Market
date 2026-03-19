import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/service_locator.dart';
import '../bloc/search_bloc.dart';
import '../widgets/search_page_body.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({required this.onOpenProduct, super.key});

  final void Function(String productId) onOpenProduct;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (_) => locator<SearchBloc>(),
      child: SearchPageBody(onOpenProduct: onOpenProduct),
    );
  }
}
