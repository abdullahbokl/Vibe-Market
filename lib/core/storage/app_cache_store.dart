import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

class AppCacheStore {
  AppCacheStore._(this._box);

  static const String _boxName = 'vibemarket_cache_box';

  static Future<AppCacheStore> open() async {
    final Box<String> box = await Hive.openBox<String>(_boxName);
    return AppCacheStore._(box);
  }

  final Box<String> _box;

  Future<void> putString(String key, String value) {
    return _box.put(key, value);
  }

  String? readString(String key) {
    return _box.get(key);
  }

  Future<void> putJson(String key, Map<String, dynamic> value) {
    return _box.put(key, jsonEncode(value));
  }

  Map<String, dynamic>? readJson(String key) {
    final String? rawValue = _box.get(key);
    if (rawValue == null) {
      return null;
    }
    final Object? decoded = jsonDecode(rawValue);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    return null;
  }

  Future<void> putJsonList(String key, List<Map<String, dynamic>> value) {
    return _box.put(key, jsonEncode(value));
  }

  List<Map<String, dynamic>> readJsonList(String key) {
    final String? rawValue = _box.get(key);
    if (rawValue == null) {
      return const <Map<String, dynamic>>[];
    }
    final Object? decoded = jsonDecode(rawValue);
    if (decoded is List<dynamic>) {
      return decoded
          .whereType<Map<String, dynamic>>()
          .map((Map<String, dynamic> item) => item)
          .toList();
    }
    return const <Map<String, dynamic>>[];
  }

  Future<void> delete(String key) {
    return _box.delete(key);
  }
}
