import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/performance/performance_trace.dart';
import '../bloc/search_bloc.dart';
import 'search_query_field.dart';
import 'search_state_view.dart';
import 'search_suggestions_view.dart';

class SearchPageBody extends StatefulWidget {
  const SearchPageBody({required this.onOpenProduct, super.key});

  final void Function(String productId) onOpenProduct;

  @override
  State<SearchPageBody> createState() => _SearchPageBodyState();
}

class _SearchPageBodyState extends State<SearchPageBody> {
  late final TextEditingController _controller;
  late final ScrollController _scrollController;
  late final FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    PerformanceTrace.start('search.first-content');
    _controller = TextEditingController();
    _scrollController = ScrollController()..addListener(_onScroll);
    _focusNode = FocusNode()..addListener(_onFocusChange);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SearchBloc>().add(const SearchStarted());
      }
    });
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  Timer? _scrollDebounceTimer;

  @override
  void dispose() {
    _scrollDebounceTimer?.cancel();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _focusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients || _scrollDebounceTimer?.isActive == true) {
      return;
    }
    final double remaining =
        _scrollController.position.maxScrollExtent -
        _scrollController.position.pixels;
    if (remaining <= 320) {
      _scrollDebounceTimer = Timer(const Duration(milliseconds: 100), () {
        if (mounted) {
          context.read<SearchBloc>().add(const SearchNextPageRequested());
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchBloc, SearchState>(
      listenWhen: (prev, curr) => prev.query != curr.query,
      listener: (context, state) {
        if (_controller.text != state.query) {
          _controller.text = state.query;
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
        }
      },
      child: GestureDetector(
        onTap: () {
          if (_focusNode.hasFocus) _focusNode.unfocus();
        },
        behavior: HitTestBehavior.opaque,
        child: Scaffold(
          appBar: AppBar(title: const Text('Semantic Search')),
          body: Column(
            children: <Widget>[
              SearchQueryField(controller: _controller, focusNode: _focusNode),
              Expanded(
                child: Stack(
                  children: [
                    SearchStateView(
                      scrollController: _scrollController,
                      onOpenProduct: widget.onOpenProduct,
                    ),
                    if (_isFocused && _controller.text.trim().isEmpty)
                      Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: const SearchSuggestionsView(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
