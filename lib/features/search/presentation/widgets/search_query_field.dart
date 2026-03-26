import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/search_bloc.dart';

class SearchQueryField extends StatelessWidget {
  const SearchQueryField({
    required this.controller,
    required this.focusNode,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: (String value) {
                context.read<SearchBloc>().add(SearchQueryChanged(value));
              },
              decoration: InputDecoration(
                hintText: 'Search by vibe, mood, or drop',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          controller.clear();
                          context.read<SearchBloc>().add(const SearchCleared());
                        },
                        icon: const Icon(Icons.clear, size: 20),
                      )
                    : null,
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: focusNode.hasFocus
                ? TextButton(
                    onPressed: () {
                      controller.clear();
                      focusNode.unfocus();
                      context.read<SearchBloc>().add(const SearchCleared());
                    },
                    child: const Text('Cancel'),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
