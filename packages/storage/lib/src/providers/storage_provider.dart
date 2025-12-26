/// Abstract storage provider interface
/// Allows different implementations (local, cloud, etc.)
abstract class StorageProvider {
  /// Save data with a key
  Future<void> save(String key, dynamic value);

  /// Retrieve data by key
  Future<T?> get<T>(String key);

  /// Delete data by key
  Future<void> delete(String key);

  /// Check if key exists
  Future<bool> contains(String key);

  /// Clear all storage
  Future<void> clear();

  /// Get all keys
  Future<List<String>> getKeys();

  /// Save object (JSON serializable)
  Future<void> saveObject(String key, Map<String, dynamic> object);

  /// Get object (JSON deserialized)
  Future<Map<String, dynamic>?> getObject(String key);
}
