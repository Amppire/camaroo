import 'package:flutter/material.dart';
import 'native_camera_controller.dart';

/// Native Camera Preview Widget
/// 
/// Displays the camera preview using a native texture
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

        return Texture(textureId: textureId);
      },
    );
  }
}

