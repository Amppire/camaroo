import 'dart:convert';
import '../storage_service.dart';
import '../exceptions/storage_exceptions.dart';
import '../models/photo.dart';
import '../abstractions/photo_storage_service_api.dart';

class PhotoStorageService implements PhotoStorageServiceApi {
  static const String _photosKey = 'photos';
  static const String _photoCountKey = 'photoCount';

  final StorageService _storageService;

  PhotoStorageService({required StorageService storageService}) : _storageService = storageService;

  @override
  Future<void> savePhoto(Photo photo) async {
    try {
      final photos = await getAllPhotos();
      photos.insert(0, photo);

      await _storageService.save(_photosKey, jsonEncode(photos.map((p) => p.toJson()).toList()));
      await _storageService.save(_photoCountKey, photos.length);

      print('✅ Photo saved: ${photo.id}');
    } catch (e) {
      print('❌ Error saving photo: $e');
      throw StorageException('Failed to save photo: $e');
    }
  }

  @override
  Future<List<Photo>> getAllPhotos() async {
    try {
      final photosJson = await _storageService.get<String>(_photosKey);
      if (photosJson == null) return [];

      final List<dynamic> photosList = jsonDecode(photosJson);
      return photosList.map((json) => Photo.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      print('❌ Error getting photos: $e');
      return [];
    }
  }
}
