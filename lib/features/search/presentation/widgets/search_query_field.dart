import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/search_bloc.dart';

class SearchQueryField extends StatelessWidget {
  const SearchQueryField({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        onChanged: (String value) {
          context.read<SearchBloc>().add(SearchQueryChanged(value));
        },
        decoration: InputDecoration(
          hintText: 'Search by vibe, material, drop, or mood',
          suffixIcon: IconButton(
            onPressed: () {
              controller.clear();
              context.read<SearchBloc>().add(const SearchCleared());
            },
            icon: const Icon(Icons.clear),
          ),
        ),
      ),
    );
  }
}
