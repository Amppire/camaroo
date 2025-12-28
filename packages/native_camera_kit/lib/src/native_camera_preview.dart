import 'package:flutter/material.dart';
import 'native_camera_controller.dart';

/// Native Camera Preview Widget
/// 
/// Displays the camera preview using a native texture with correct aspect ratio
class NativeCameraPreview extends StatelessWidget {
  const NativeCameraPreview({
    super.key,
    required this.controller,
  });

  final NativeCameraController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int?>(
      valueListenable: controller.textureId,
      builder: (context, textureId, child) {
        if (textureId == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Get the camera's aspect ratio
        return ValueListenableBuilder<double?>(
          valueListenable: controller.aspectRatio,
          builder: (context, aspectRatio, child) {
            if (aspectRatio == null) {
              return Texture(textureId: textureId);
            }

            // The camera outputs in landscape orientation (width > height)
            // For portrait mode, we need to invert the aspect ratio
            // Camera: 16:9 landscape → Display: 9:16 portrait
            final portraitAspectRatio = 1.0 / aspectRatio;

            return Center(
              child: AspectRatio(
                aspectRatio: portraitAspectRatio,
                child: Texture(textureId: textureId),
              ),
            );
          },
        );
      },
    );
  }
}

