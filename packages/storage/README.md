# 📦 Storage Package

A platform-agnostic storage package for Flutter that provides a unified interface for local and cloud storage operations with domain-specific services.

## 🎯 Features

- ✅ **Platform Agnostic** - Works across iOS, Android, Web, and Desktop
- ✅ **Provider Pattern** - Swap between local and cloud storage implementations
- ✅ **Domain-Specific Services** - Built-in photo storage with extensibility for more
- ✅ **Type Safe** - Full Dart type safety with generics
- ✅ **Facade Pattern** - Clean, unified API through `StorageService`
- ✅ **Testable** - Abstract interfaces for easy mocking
- ✅ **Extensible** - Add custom storage providers and domain services

## 📋 Table of Contents

- [Installation](#installation)
- [Quick Start](#quick-start)
- [Architecture](#architecture)
- [Usage](#usage)
  - [Generic Storage](#generic-storage)
  - [Photo Storage](#photo-storage)
- [Advanced Usage](#advanced-usage)
- [Custom Providers](#custom-providers)
- [Testing](#testing)

## 🚀 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  storage:
    path: ../packages/storage
```

Then run:

```bash
flutter pub get
```

## ⚡ Quick Start

```dart
import 'package:storage/storage.dart';

// Generic key-value storage
await StorageService.instance.save('username', 'john_doe');
final username = await StorageService.instance.get<String>('username');

// Photo storage (domain-specific service)
final photo = Photo(
  id: 'photo_123',
  filePath: '/path/to/photo.jpg',
  capturedAt: DateTime.now(),
);
await StorageService.instance.photos.savePhoto(photo);
final photos = await StorageService.instance.photos.getAllPhotos();
```

## 🏗️ Architecture

### Structure

```
storage/
├── lib/
│   ├── storage.dart                          # Main export file
│   └── src/
│       ├── services/
│       │   ├── storage_service.dart          # Main facade service
│       │   └── photo_storage_service.dart    # Photo domain service
│       ├── abstractions/
│       │   └── photo_storage_service_api.dart # Photo service interface
│       ├── providers/
│       │   ├── storage_provider.dart         # Abstract provider
│       │   ├── local_storage_provider.dart   # Local implementation
│       │   └── cloud_storage_provider.dart   # Cloud implementation (WIP)
│       ├── models/
│       │   ├── storage_model.dart            # Generic storage model
│       │   └── photo.dart                    # Photo model
│       └── exceptions/
│           └── storage_exceptions.dart       # Custom exceptions
```

### Design Patterns

- **Facade Pattern**: `StorageService` provides unified access to all storage operations
- **Provider Pattern**: Swap storage backends (local, cloud) without code changes
- **Repository Pattern**: Domain services abstract storage logic from business logic
- **Dependency Injection**: Services accept abstractions for testability

## 📖 Usage

### Generic Storage

Store and retrieve any serializable data:

```dart
// Save primitive types
await StorageService.instance.save('count', 42);
await StorageService.instance.save('isActive', true);
await StorageService.instance.save('username', 'john_doe');

// Retrieve with type safety
final count = await StorageService.instance.get<int>('count');
final isActive = await StorageService.instance.get<bool>('isActive');

// Save/retrieve objects
await StorageService.instance.saveObject('user', {
  'id': '123',
  'name': 'John Doe',
  'email': 'john@example.com',
});
final user = await StorageService.instance.getObject('user');

// Check existence
final exists = await StorageService.instance.contains('username');

// Delete
await StorageService.instance.delete('username');

// Get all keys
final keys = await StorageService.instance.getKeys();

// Clear all storage
await StorageService.instance.clear();
```

### Photo Storage

Domain-specific photo management:

```dart
import 'package:storage/storage.dart';

// Save a photo
final photo = Photo(
  id: 'photo_001',
  filePath: '/storage/photos/image.jpg',
  capturedAt: DateTime.now(),
  cameraType: 'back',
  hasFlash: false,
);
await StorageService.instance.photos.savePhoto(photo);

// Get all photos
final allPhotos = await StorageService.instance.photos.getAllPhotos();

// Get most recent photo
final latestPhoto = await StorageService.instance.photos.getMostRecentPhoto();

// Get photo by ID
final photo = await StorageService.instance.photos.getPhotoById('photo_001');

// Get photo count
final count = await StorageService.instance.photos.getPhotoCount();

// Filter photos
final todayPhotos = await StorageService.instance.photos.getTodayPhotos();
final frontCamera = await StorageService.instance.photos.getPhotosByCameraType('front');
final flashPhotos = await StorageService.instance.photos.getPhotosWithFlash();

// Date range query
final dateRange = await StorageService.instance.photos.getPhotosByDateRange(
  DateTime(2024, 1, 1),
  DateTime(2024, 12, 31),
);

// Delete photo
await StorageService.instance.photos.deletePhoto('photo_001');

// Clear all photos
await StorageService.instance.photos.clearAllPhotos();
```

## 🔧 Advanced Usage

### Initialize with Custom Provider

```dart
import 'package:storage/storage.dart';

void main() {
  // Initialize with cloud provider
  StorageService.initialize(
    provider: CloudStorageProvider(
      bucketName: 'my-app-bucket',
      config: {'region': 'us-east-1'},
    ),
  );
  
  runApp(MyApp());
}
```

### Dependency Injection

```dart
class MyService {
  final StorageService storage;
  
  MyService({required this.storage});
  
  Future<void> saveUserPreference(String key, dynamic value) async {
    await storage.save('preferences_$key', value);
  }
}

// Usage
final service = MyService(storage: StorageService.instance);
```

### Using Photo Service Independently

```dart
// Create a standalone photo service
final photoService = PhotoStorageService(
  storageService: StorageService.instance,
);

await photoService.savePhoto(photo);
final photos = await photoService.getAllPhotos();
```

## 🛠️ Custom Providers

Create your own storage provider:

```dart
import 'package:storage/storage.dart';

class CustomStorageProvider implements StorageProvider {
  @override
  Future<void> save(String key, dynamic value) async {
    // Your custom implementation
  }

  @override
  Future<T?> get<T>(String key) async {
    // Your custom implementation
  }

  // Implement other methods...
}

// Use it
StorageService.initialize(provider: CustomStorageProvider());
```

## 🧪 Testing

### Mock Photo Storage Service

```dart
import 'package:storage/storage.dart';

class MockPhotoStorageService implements PhotoStorageServiceApi {
  final List<Photo> _photos = [];

  @override
  Future<void> savePhoto(Photo photo) async {
    _photos.insert(0, photo);
  }

  @override
  Future<List<Photo>> getAllPhotos() async {
    return List.from(_photos);
  }
  
  // Implement other methods...
}

// Use in tests
void main() {
  test('should save photo', () async {
    final mockService = MockPhotoStorageService();
    final photo = Photo(
      id: 'test',
      filePath: '/test.jpg',
      capturedAt: DateTime.now(),
    );
    
    await mockService.savePhoto(photo);
    final photos = await mockService.getAllPhotos();
    
    expect(photos.length, 1);
    expect(photos.first.id, 'test');
  });
}
```

### Testing with Dependency Injection

```dart
void main() {
  test('camera should save photos', () async {
    final mockPhotoService = MockPhotoStorageService();
    final storage = StorageService(
      provider: LocalStorageProvider(),
    );
    
    // Inject mock service
    final camera = CameraService(
      storage: storage,
      photoService: mockPhotoService,
    );
    
    await camera.takePicture();
    
    final count = await mockPhotoService.getPhotoCount();
    expect(count, 1);
  });
}
```

## 📝 API Reference

### StorageService

Main facade providing access to all storage operations.

#### Generic Storage Methods

- `save(String key, dynamic value)` - Save a value
- `get<T>(String key)` - Retrieve a value
- `delete(String key)` - Delete a value
- `contains(String key)` - Check if key exists
- `clear()` - Clear all storage
- `getKeys()` - Get all keys
- `saveObject(String key, Map<String, dynamic> object)` - Save JSON object
- `getObject(String key)` - Retrieve JSON object

#### Domain Services

- `photos` - Access to `PhotoStorageServiceApi`

### PhotoStorageServiceApi

Photo-specific storage operations.

#### Methods

- `savePhoto(Photo photo)` - Save a photo
- `getAllPhotos()` - Get all photos
- `getMostRecentPhoto()` - Get the latest photo
- `getPhotoById(String id)` - Find photo by ID
- `deletePhoto(String id)` - Delete a photo
- `getPhotoCount()` - Get total count
- `clearAllPhotos()` - Delete all photos
- `getPhotosByDateRange(DateTime start, DateTime end)` - Filter by date
- `getTodayPhotos()` - Get today's photos
- `getPhotosByCameraType(String type)` - Filter by camera type
- `getPhotosWithFlash()` - Get photos taken with flash

## 🎨 Photo Model

```dart
class Photo {
  final String id;               // Unique identifier
  final String filePath;         // Path to image file
  final DateTime capturedAt;     // Capture timestamp
  final String? cameraType;      // 'front' or 'back'
  final bool hasFlash;           // Flash enabled flag
}
```

## 🚀 Future Enhancements

- [ ] Cloud storage provider (Firebase, AWS S3, Azure)
- [ ] Video storage service
- [ ] Settings storage service
- [ ] User profile storage service
- [ ] Encryption support
- [ ] Compression support
- [ ] Sync between local and cloud
- [ ] Offline-first capabilities
- [ ] Migration utilities

## 📄 License

This package is part of the Camaroo project.

## 🤝 Contributing

Contributions are welcome! Please follow these guidelines:

1. Create domain-specific services in `src/services/`
2. Define abstractions in `src/abstractions/`
3. Add models to `src/models/`
4. Export new services in `lib/storage.dart`
5. Update this README with examples

---

Made with ❤️ for the Camaroo project

