import 'package:flutter/material.dart';
import '../models/album.dart';
import '../services/gallery_service.dart';
import 'package:provider/provider.dart';
import '../widgets/photo_grid.dart';

class AlbumDetailScreen extends StatelessWidget {
  final Album album;

  const AlbumDetailScreen({
    super.key,
    required this.album,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(album.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Album'),
                  content: const Text('Are you sure you want to delete this album?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<GalleryService>().deleteAlbum(album.id);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<GalleryService>(
        builder: (context, galleryService, child) {
          final photos = galleryService.getPhotosByAlbum(album.id);
          
          if (photos.isEmpty) {
            return const Center(
              child: Text(
                'No photos in this album',
                style: TextStyle(color: Colors.white54),
              ),
            );
          }
          
          return PhotoGrid(photos: photos);
        },
      ),
    );
  }
}
