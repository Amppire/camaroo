import 'dart:convert';

import 'package:storage/storage.dart';
import 'package:storage/src/models/photo.dart';
import 'package:storage/src/abstractions/photo_storage_service_api.dart';

class PhotoStorageService implements PhotoStorageServiceApi {
  static const String _photosKey = 'photos';
  static const String _photoCountKey = 'photoCount';

  final StorageService _storageService;

  PhotoStorageService({required StorageService storageService}) : _storageService = storageService;

  /// Save a captured photo
  @override
  Future<void> savePhoto(Photo photo) async {
    try {
      // Get existing photos
      final photos = await getAllPhotos();

      // Add new photo to the beginning (most recent first)
      photos.insert(0, photo);

      // Save updated list
      await _storageService.save(_photosKey, jsonEncode(photos.map((p) => p.toJson()).toList()));

      // Update count
      await _storageService.save(_photoCountKey, photos.length);

      print('✅ Photo saved: ${photo.id}');
    } catch (e) {
      print('❌ Error saving photo: $e');
      throw StorageException('Failed to save photo: $e');
    }
  }

  /// Get all captured photos
  @override
  Future<List<Photo>> getAllPhotos() async {
    try {
      final photosJson = await _storageService.get<String>(_photosKey);

      if (photosJson == null) {
        return [];
      }

      final List<dynamic> photosList = jsonDecode(photosJson);
      return photosList.map((json) => Photo.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      print('❌ Error getting photos: $e');
      return [];
    }
  }
}
