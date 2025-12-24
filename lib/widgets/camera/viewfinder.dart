import 'package:camaroo/core/abstractions/camera_api.dart';
import 'package:camaroo/adapters/camera_adapter.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class Viewfinder extends StatelessWidget {
  const Viewfinder({super.key, required this.cameraApi, required this.cameraAdapter, required this.status});
  final CameraApi cameraApi;
  final CameraAdapter cameraAdapter;
  final CameraStatus status;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CameraController?>(
      valueListenable: cameraAdapter.cameraControllerNotifier,
      builder: (context, controller, _) {
        if (status == CameraStatus.initializing) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          );
        }

        if (status == CameraStatus.error || controller == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.camera_alt_outlined,
                  size: 80,
                  color: Colors.white30,
                ),
                const SizedBox(height: 24),
                ValueListenableBuilder<String?>(
                  valueListenable: cameraAdapter.errorMessageNotifier,
                  builder: (context, error, _) {
                    return Text(
                      error ?? 'Camera not available',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    );
                  },
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () => cameraApi.initializeCamera(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    backgroundColor: Colors.white.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Try Again',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }

        if (!controller.value.isInitialized) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          );
        }

        // Full-screen camera preview
        final size = MediaQuery.of(context).size;
        return SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: size.width,
              height: size.width * controller.value.aspectRatio,
              child: CameraPreview(controller),
            ),
          ),
        );
      },
    );
  }
}