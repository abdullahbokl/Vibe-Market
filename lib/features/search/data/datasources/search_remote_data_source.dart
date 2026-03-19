import 'package:supabase_flutter/supabase_flutter.dart';

class SearchRemoteDataSource {
  const SearchRemoteDataSource(this._client);

  final SupabaseClient _client;

  Future<FunctionResponse> semanticSearch(String query) {
    return _client.functions.invoke(
      'semantic-search',
      body: <String, dynamic>{'query': query},
    );
  }

  Future<List<Map<String, dynamic>>> browseProducts({
    required int offset,
    required int limit,
  }) async {
    final List<dynamic> response = await _client
        .from('products')
        .select('''
          id,
          title,
          tagline,
          price_cents,
          currency_code,
          hero_image_url,
          seller_display_name,
          seller_handle,
          sale_end_time,
          drop_label,
          tag_list,
          inventory:inventory!left(
            available_count,
            total_count
          )
        ''')
        .order('sort_rank', ascending: false)
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);
    return response
        .whereType<Map<dynamic, dynamic>>()
        .map((Map<dynamic, dynamic> row) => Map<String, dynamic>.from(row))
        .toList();
  }
}
