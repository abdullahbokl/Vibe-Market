import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/search_bloc.dart';

class SearchSuggestionsView extends StatelessWidget {
  const SearchSuggestionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 250),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            behavior: HitTestBehavior.translucent,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: <Widget>[
                const SizedBox(height: 8),
                _buildSectionHeader(context, 'Trending Vibes'),
                _buildChipCloud(context, [
                  'Cyberpunk Streetwear',
                  'Professional Adventure',
                  'Quiet Luxury',
                  'Sustainable Apparel',
                  'Retro-Futurism',
                ]),
                const SizedBox(height: 24),
                _buildSectionHeader(context, 'Popular Materials'),
                _buildChipCloud(context, [
                  'Mushroom Leather',
                  'Mulberry Silk',
                  'Recycled Algae',
                  'Hemp',
                  'Titanium',
                  'Organic Cotton',
                ]),
                const SizedBox(height: 24),
                _buildSectionHeader(context, 'Featured Drops'),
                _buildSuggestionTile(context, 'Arctic Vanguard Parka', 'vanguard parka'),
                _buildSuggestionTile(context, 'Synth-Wave Bomber', 'bomber jacket'),
                _buildSuggestionTile(context, 'Mycelium Leather Tote', 'mushroom tote'),
                _buildSuggestionTile(context, 'Monolith Wool Coat', 'monolith coat'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
            ),
      ),
    );
  }

  Widget _buildChipCloud(BuildContext context, List<String> items) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items
          .map((item) => ActionChip(
                label: Text(item),
                onPressed: () {
                  context.read<SearchBloc>().add(SearchQueryChanged(item));
                },
              ))
          .toList(),
    );
  }

  Widget _buildSuggestionTile(BuildContext context, String title, String query) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.trending_up, size: 20),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: () {
        context.read<SearchBloc>().add(SearchQueryChanged(query));
      },
    );
  }
}
