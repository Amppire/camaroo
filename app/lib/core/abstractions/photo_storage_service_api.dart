import 'package:camaroo/data_models/photo.dart';

abstract class PhotoStorageServiceApi {
  Future<void> savePhoto(Photo photo);
  Future<List<Photo>> getAllPhotos();
}
