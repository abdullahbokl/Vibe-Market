import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/performance/performance_trace.dart';
import '../bloc/search_bloc.dart';
import 'search_query_field.dart';
import 'search_state_view.dart';

class SearchPageBody extends StatefulWidget {
  const SearchPageBody({required this.onOpenProduct, super.key});

  final void Function(String productId) onOpenProduct;

  @override
  State<SearchPageBody> createState() => _SearchPageBodyState();
}

class _SearchPageBodyState extends State<SearchPageBody> {
  late final TextEditingController _controller;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    PerformanceTrace.start('search.first-content');
    _controller = TextEditingController();
    _scrollController = ScrollController()..addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SearchBloc>().add(const SearchStarted());
      }
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }
    final double remaining =
        _scrollController.position.maxScrollExtent -
        _scrollController.position.pixels;
    if (remaining <= 320) {
      context.read<SearchBloc>().add(const SearchNextPageRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Semantic Search')),
      body: Column(
        children: <Widget>[
          SearchQueryField(controller: _controller),
          Expanded(
            child: SearchStateView(
              scrollController: _scrollController,
              onOpenProduct: widget.onOpenProduct,
            ),
          ),
        ],
      ),
    );
  }
}
