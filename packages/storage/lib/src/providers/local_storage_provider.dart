import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'storage_provider.dart';

/// Local storage implementation using SharedPreferences
class LocalStorageProvider implements StorageProvider {
  SharedPreferences? _prefs;

  Future<SharedPreferences> get prefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  @override
  Future<void> save(String key, dynamic value) async {
    final p = await prefs;

    if (value is String) {
      await p.setString(key, value);
    } else if (value is int) {
      await p.setInt(key, value);
    } else if (value is double) {
      await p.setDouble(key, value);
    } else if (value is bool) {
      await p.setBool(key, value);
    } else if (value is List<String>) {
      await p.setStringList(key, value);
    } else {
      // For complex objects, convert to JSON string
      await p.setString(key, jsonEncode(value));
    }
  }

  @override
  Future<T?> get<T>(String key) async {
    final p = await prefs;
    final value = p.get(key);

    if (value == null) return null;

    // Try to decode JSON if it's a string and T is not String
    if (value is String && T != String) {
      try {
        return jsonDecode(value) as T;
      } catch (_) {
        return value as T;
      }
    }

    return value as T;
  }

  @override
  Future<void> delete(String key) async {
    final p = await prefs;
    await p.remove(key);
  }

  @override
  Future<bool> contains(String key) async {
    final p = await prefs;
    return p.containsKey(key);
  }

  @override
  Future<void> clear() async {
    final p = await prefs;
    await p.clear();
  }

  @override
  Future<List<String>> getKeys() async {
    final p = await prefs;
    return p.getKeys().toList();
  }

  @override
  Future<void> saveObject(String key, Map<String, dynamic> object) async {
    final p = await prefs;
    await p.setString(key, jsonEncode(object));
  }

  @override
  Future<Map<String, dynamic>?> getObject(String key) async {
    final p = await prefs;
    final value = p.getString(key);

    if (value == null) return null;

    try {
      return jsonDecode(value) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}
