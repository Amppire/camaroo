import 'package:camaroo/core/abstractions/camera_api.dart';
import 'package:camaroo/adapters/camera_adapter.dart';
import 'package:flutter/material.dart';
import 'package:native_camera_kit/native_camera_kit.dart' as native_camera_kit;

/// Heart of the camera app. Displays the live camera feed. This takes up the entire screen.
/// TODO: Add pinch to zoom.
class Viewfinder extends StatelessWidget {
  const Viewfinder({super.key, required this.cameraApi, required this.cameraAdapter, required this.status});
  final CameraApi cameraApi;
  final CameraAdapter cameraAdapter;
  final native_camera_kit.CameraStatus status;

  @override
  Widget build(BuildContext context) {
   
          if (status == native_camera_kit.CameraStatus.initializing) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          );
        }

        if (status == native_camera_kit.CameraStatus.error ) {
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

        // if (!ce) {
        //   return const Center(
        //     child: CircularProgressIndicator(
        //       color: Colors.white,
        //       strokeWidth: 2,
        //     ),
        //   );
        // }

        // Full-screen camera preview
        final size = MediaQuery.of(context).size;
        return SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: native_camera_kit.NativeCameraPreview(controller: cameraApi.cameraNativeController ?? native_camera_kit.NativeCameraController()),
            ),
          ),
        );
      
    
  }
}