import 'dart:io';
import 'package:camera/camera.dart';
import 'package:camaroo/adapters/camera_adapter.dart';
import 'package:camaroo/core/abstractions/camera_api.dart';
import 'package:camaroo/core/models/camera_model.dart';
import 'package:flutter/material.dart';

class SimpleCameraScreen extends StatefulWidget {
  const SimpleCameraScreen({super.key});

  @override
  State<SimpleCameraScreen> createState() => _SimpleCameraScreenState();
}

class _SimpleCameraScreenState extends State<SimpleCameraScreen> {
  late final CameraApi cameraApi;
  late final CameraAdapter cameraAdapter;

  @override
  void initState() {
    super.initState();
    
    // Initialize model and adapter following your architecture
    cameraApi = CameraApiModel();
    cameraAdapter = CameraAdapter(cameraApi);
    
    // Start camera initialization
    cameraApi.initializeCamera();
  }

  @override
  void dispose() {
    // Clean up controller
    if (cameraApi is CameraApiModel) {
      (cameraApi as CameraApiModel).dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
        actions: [
          // Flash toggle button
          ValueListenableBuilder<FlashMode?>(
            valueListenable: cameraAdapter.flashModeNotifier,
            builder: (context, flashMode, _) {
              return IconButton(
                icon: Icon(_getFlashIcon(flashMode)),
                onPressed: () => cameraApi.toggleFlash(),
              );
            },
          ),
          // Switch camera button
          ValueListenableBuilder<List<CameraDescription>>(
            valueListenable: cameraAdapter.camerasNotifier,
            builder: (context, cameras, _) {
              if (cameras.length <= 1) return const SizedBox.shrink();
              return IconButton(
                icon: const Icon(Icons.flip_camera_android),
                onPressed: () => cameraApi.switchCamera(),
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder<CameraStatus>(
        valueListenable: cameraAdapter.statusNotifier,
        builder: (context, status, _) {
          return Column(
            children: [
              // Camera preview
              Expanded(
                child: _buildCameraPreview(status),
              ),
              
              // Error message
              ValueListenableBuilder<String?>(
                valueListenable: cameraAdapter.errorMessageNotifier,
                builder: (context, error, _) {
                  if (error == null) return const SizedBox.shrink();
                  return Container(
                    width: double.infinity,
                    color: Colors.red.shade100,
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      error,
                      style: TextStyle(color: Colors.red.shade900),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
              
              // Controls
              _buildControls(status),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCameraPreview(CameraStatus status) {
    return ValueListenableBuilder<CameraController?>(
      valueListenable: cameraAdapter.cameraControllerNotifier,
      builder: (context, controller, _) {
        if (status == CameraStatus.initializing) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (status == CameraStatus.error || controller == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                ValueListenableBuilder<String?>(
                  valueListenable: cameraAdapter.errorMessageNotifier,
                  builder: (context, error, _) {
                    return Text(
                      error ?? 'Camera not available',
                      style: const TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    );
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => cameraApi.initializeCamera(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (!controller.value.isInitialized) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show camera preview
        return Center(
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: CameraPreview(controller),
          ),
        );
      },
    );
  }

  Widget _buildControls(CameraStatus status) {
    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Last picture taken thumbnail
          ValueListenableBuilder<XFile?>(
            valueListenable: cameraAdapter.pictureTakenNotifier,
            builder: (context, picture, _) {
              if (picture == null) {
                return Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.photo, color: Colors.white),
                );
              }
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(picture.path),
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
          
          // Capture button
          GestureDetector(
            onTap: status == CameraStatus.ready
                ? () => cameraApi.takePicture()
                : null,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                color: status == CameraStatus.takingPicture
                    ? Colors.grey
                    : Colors.white,
              ),
              child: status == CameraStatus.takingPicture
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
          ),
          
          // Spacer for symmetry
          const SizedBox(width: 64),
        ],
      ),
    );
  }

  IconData _getFlashIcon(FlashMode? mode) {
    switch (mode) {
      case FlashMode.off:
        return Icons.flash_off;
      case FlashMode.auto:
        return Icons.flash_auto;
      case FlashMode.always:
        return Icons.flash_on;
      case FlashMode.torch:
        return Icons.highlight;
      case null:
        return Icons.flash_off;
    }
  }
}