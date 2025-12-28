import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';

/// Thumbnail for the gallery. Displays the last picture taken and is used to navigate to the gallery.
// TODO: Add a way to navigate to the gallery.
class GalleryThumbnail extends StatelessWidget {
  
  const GalleryThumbnail({super.key});

  @override
  Widget build(BuildContext context) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.photo_library_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      );
    }

  
  
}