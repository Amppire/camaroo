import 'package:storage/src/models/photo.dart';

abstract class PhotoStorageServiceApi {
  /// Saves a photo to the storage.
  ///
  /// @param photo The photo to save.
  /// @return void
  Future<void> savePhoto(Photo photo);

  /// Gets all photos from the storage.
  ///
  /// @return List<Photo> A list of all photos.
  Future<List<Photo>> getAllPhotos();
}
