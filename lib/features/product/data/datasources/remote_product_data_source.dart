import 'package:supabase_flutter/supabase_flutter.dart';

class RemoteProductDataSource {
  const RemoteProductDataSource(this._client);

  final SupabaseClient _client;

  Future<Map<String, dynamic>?> fetchProductById(String productId) {
    return _client
        .from('products')
        .select(
          'id, title, tagline, description, seller_display_name, seller_handle, '
          'price_cents, currency_code, hero_image_url, sale_end_time, drop_label, '
          'tag_list, inventory(available_count, total_count), '
          'product_media(id, media_url, media_type, position)',
        )
        .eq('id', productId)
        .maybeSingle();
  }

  Future<List<Map<String, dynamic>>> fetchProductsByIds(List<String> productIds) async {
    final List<dynamic> response = await _client
        .from('products')
        .select(
          'id, title, tagline, seller_display_name, seller_handle, '
          'price_cents, currency_code, hero_image_url, sale_end_time, '
          'drop_label, tag_list, inventory(available_count, total_count)',
        )
        .inFilter('id', productIds)
        .order('sort_rank', ascending: false);
    return response
        .whereType<Map<String, dynamic>>()
        .map(Map<String, dynamic>.from)
        .toList();
  }
}
