import 'providers/storage_provider.dart';
import 'providers/local_storage_provider.dart';
import 'exceptions/storage_exceptions.dart';

/// Main storage service that uses a provider pattern
class StorageService {
  final StorageProvider _provider;

  StorageService({StorageProvider? provider}) : _provider = provider ?? LocalStorageProvider();

  /// Singleton instance for convenience
  static StorageService? _instance;

  static StorageService get instance {
    _instance ??= StorageService();
    return _instance!;
  }

  /// Initialize with a custom provider
  static void initialize({required StorageProvider provider}) {
    _instance = StorageService(provider: provider);
  }

  /// Save data with a key
  Future<void> save(String key, dynamic value) async {
    try {
      await _provider.save(key, value);
    } catch (e) {
      throw StorageException('Failed to save: $e');
    }
  }

  /// Retrieve data by key
  Future<T?> get<T>(String key) async {
    try {
      return await _provider.get<T>(key);
    } catch (e) {
      throw StorageException('Failed to retrieve: $e');
    }
  }

  /// Delete data by key
  Future<void> delete(String key) async {
    try {
      await _provider.delete(key);
    } catch (e) {
      throw StorageException('Failed to delete: $e');
    }
  }

  /// Check if key exists
  Future<bool> contains(String key) async {
    try {
      return await _provider.contains(key);
    } catch (e) {
      throw StorageException('Failed to check key: $e');
    }
  }

  /// Clear all storage
  Future<void> clear() async {
    try {
      await _provider.clear();
    } catch (e) {
      throw StorageException('Failed to clear: $e');
    }
  }

  /// Get all keys
  Future<List<String>> getKeys() async {
    try {
      return await _provider.getKeys();
    } catch (e) {
      throw StorageException('Failed to get keys: $e');
    }
  }

  /// Save object (with JSON serialization)
  Future<void> saveObject(String key, Map<String, dynamic> object) async {
    await _provider.saveObject(key, object);
  }

  /// Get object (with JSON deserialization)
  Future<Map<String, dynamic>?> getObject(String key) async {
    return await _provider.getObject(key);
  }
}
