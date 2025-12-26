import 'providers/storage_provider.dart';
import 'providers/local_storage_provider.dart';
import 'exceptions/storage_exceptions.dart';
import 'abstractions/photo_storage_service_api.dart';
import 'services/photo_storage_service.dart';

/// Main storage service that uses a provider pattern
/// Provides access to both generic storage and domain-specific services
class StorageService {
  final StorageProvider _provider;

  // Lazy-initialized domain-specific services
  PhotoStorageServiceApi? _photoStorageService;

  StorageService({StorageProvider? provider, PhotoStorageServiceApi? photoStorageService})
    : _provider = provider ?? LocalStorageProvider(),
      _photoStorageService = photoStorageService;

  /// Singleton instance for convenience
  static StorageService? _instance;

  static StorageService get instance {
    _instance ??= StorageService();
    return _instance!;
  }

  /// Initialize with a custom provider and optional service overrides
  static void initialize({
    required StorageProvider provider,
    PhotoStorageServiceApi? photoStorageService,
  }) {
    _instance = StorageService(provider: provider, photoStorageService: photoStorageService);
  }

  // ============================================================
  // Domain-Specific Services (Facade Pattern)
  // ============================================================

  /// Access to photo storage operations
  /// Usage: StorageService.instance.photos.savePhoto(photo)
  PhotoStorageServiceApi get photos {
    _photoStorageService ??= PhotoStorageService(storageService: this);
    return _photoStorageService!;
  }

  // Future services can be added here:
  // VideoStorageServiceApi get videos { ... }
  // SettingsStorageServiceApi get settings { ... }
  // UserStorageServiceApi get users { ... }

  // ============================================================
  // Generic Storage Operations
  // ============================================================

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
