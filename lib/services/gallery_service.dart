import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:uuid/uuid.dart';
import '../models/photo.dart';
import '../models/album.dart';

class GalleryService extends ChangeNotifier {
  final List<Photo> _photos = [];
  final List<Album> _albums = [];
  bool _isLoading = false;
  String? _error;

  List<Photo> get photos => _photos;
  List<Album> get albums => _albums;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> initialize() async {
    await requestPermissions();
    await loadPhotos();
    await loadAlbums();
  }

  Future<bool> requestPermissions() async {
    final result = await PhotoManager.requestPermissionExtend();
    return result.isAuth;
  }

  Future<void> loadPhotos() async {
    _isLoading = true;
    notifyListeners();

    try {
      final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );

      _photos.clear();
      
      for (var path in paths) {
        final List<AssetEntity> assets = await path.getAssetListRange(
          start: 0,
          end: await path.assetCountAsync,
        );

        for (var asset in assets) {
          final file = await asset.file;
          if (file != null) {
            _photos.add(Photo(
              id: asset.id,
              path: file.path,
              dateTaken: asset.createDateTime,
              latitude: asset.latitude,
              longitude: asset.longitude,
            ));
          }
        }
      }

      _photos.sort((a, b) => b.dateTaken.compareTo(a.dateTaken));
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load photos: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadAlbums() async {
    try {
      final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );

      _albums.clear();
      
      for (var path in paths) {
        final count = await path.assetCountAsync;
        final assets = await path.getAssetListRange(start: 0, end: 1);
        final coverFile = assets.isNotEmpty ? await assets.first.file : null;

        _albums.add(Album(
          id: path.id,
          name: path.name,
          createdAt: DateTime.now(),
          coverPhotoPath: coverFile?.path,
          photoCount: count,
        ));
      }

      notifyListeners();
    } catch (e) {
      _error = 'Failed to load albums: $e';
      notifyListeners();
    }
  }

  Future<void> createAlbum(String name) async {
    final album = Album(
      id: const Uuid().v4(),
      name: name,
      createdAt: DateTime.now(),
    );

    _albums.add(album);
    notifyListeners();
  }

  Future<void> deleteAlbum(String albumId) async {
    _albums.removeWhere((album) => album.id == albumId);
    notifyListeners();
  }

  Future<void> addPhotoToAlbum(String photoId, String albumId) async {
    final photoIndex = _photos.indexWhere((p) => p.id == photoId);
    if (photoIndex != -1) {
      _photos[photoIndex] = Photo(
        id: _photos[photoIndex].id,
        path: _photos[photoIndex].path,
        dateTaken: _photos[photoIndex].dateTaken,
        albumId: albumId,
        latitude: _photos[photoIndex].latitude,
        longitude: _photos[photoIndex].longitude,
        metadata: _photos[photoIndex].metadata,
        tags: _photos[photoIndex].tags,
        isFavorite: _photos[photoIndex].isFavorite,
      );
      notifyListeners();
    }
  }

  void toggleFavorite(String photoId) {
    final photoIndex = _photos.indexWhere((p) => p.id == photoId);
    if (photoIndex != -1) {
      _photos[photoIndex].isFavorite = !_photos[photoIndex].isFavorite;
      notifyListeners();
    }
  }

  List<Photo> getPhotosByAlbum(String albumId) {
    return _photos.where((photo) => photo.albumId == albumId).toList();
  }

  List<Photo> getFavoritePhotos() {
    return _photos.where((photo) => photo.isFavorite).toList();
  }

  List<Photo> searchPhotos(String query) {
    return _photos.where((photo) {
      return photo.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
    }).toList();
  }
}
