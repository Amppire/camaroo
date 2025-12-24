import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:camaroo/adapters/camera_adapter.dart';
import 'package:camaroo/core/abstractions/camera_api.dart';
import 'package:camaroo/core/models/camera_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Camera extends StatefulWidget {
  const Camera({super.key, required this.cameraApi, required this.cameraAdapter});
  final CameraApi cameraApi;
  final CameraAdapter cameraAdapter;

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  @override
  void initState() {
    super.initState();
    // Hide status bar for full-screen immersion
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    
    widget.cameraApi.initializeCamera();
  }

  @override
  void dispose() {
    // Restore status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    // Clean up controller
    if (widget.cameraApi is CameraApiModel) {
      (widget.cameraApi as CameraApiModel).dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ValueListenableBuilder<CameraStatus>(
        valueListenable: widget.cameraAdapter.statusNotifier,
        builder: (context, status, _) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Camera Preview (full screen)
              _buildCameraPreview(status),
              
              // Top controls overlay
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildTopControls(),
              ),
              
              // Bottom controls overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBottomControls(status),
              ),
              
              // Error message overlay
              Positioned(
                top: MediaQuery.of(context).padding.top + 60,
                left: 20,
                right: 20,
                child: _buildErrorMessage(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCameraPreview(CameraStatus status) {
    return ValueListenableBuilder<CameraController?>(
      valueListenable: widget.cameraAdapter.cameraControllerNotifier,
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
                  valueListenable: widget.cameraAdapter.errorMessageNotifier,
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
                  onPressed: () => widget.cameraApi.initializeCamera(),
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

  Widget _buildTopControls() {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Flash control
            ValueListenableBuilder<FlashMode?>(
              valueListenable: widget.cameraAdapter.flashModeNotifier,
              builder: (context, flashMode, _) {
                return _GlassButton(
                  onPressed: () => widget.cameraApi.toggleFlash(),
                  child: Icon(
                    _getFlashIcon(flashMode),
                    color: Colors.white,
                    size: 24,
                  ),
                );
              },
            ),
            
            // Close button (optional)
            _GlassButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls(CameraStatus status) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Gallery thumbnail
            ValueListenableBuilder<XFile?>(
              valueListenable: widget.cameraAdapter.pictureTakenNotifier,
              builder: (context, picture, _) {
                return _GalleryThumbnail(picture: picture);
              },
            ),
            
            // Capture button
            _CaptureButton(
              status: status,
              onPressed: () => widget.cameraApi.takePicture(),
            ),
            
            // Camera flip button
            ValueListenableBuilder<List<CameraDescription>>(
              valueListenable: widget.cameraAdapter.camerasNotifier,
              builder: (context, cameras, _) {
                if (cameras.length <= 1) {
                  return const SizedBox(width: 56); // Spacer for symmetry
                }
                return _GlassButton(
                  onPressed: () => widget.cameraApi.switchCamera(),
                  child: const Icon(
                    Icons.flip_camera_ios,
                    color: Colors.white,
                    size: 28,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return ValueListenableBuilder<String?>(
      valueListenable: widget.cameraAdapter.errorMessageNotifier,
      builder: (context, error, _) {
        if (error == null) return const SizedBox.shrink();
        
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.red.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      error,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
        return Icons.flashlight_on;
      case null:
        return Icons.flash_off;
    }
  }
}

// Glass morphism button widget
class _GlassButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  
  const _GlassButton({
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(28),
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}

// Capture button widget (iOS style)
class _CaptureButton extends StatelessWidget {
  final CameraStatus status;
  final VoidCallback onPressed;
  
  const _CaptureButton({
    required this.status,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = status == CameraStatus.ready;
    final bool isTaking = status == CameraStatus.takingPicture;
    
    return GestureDetector(
      onTap: isActive ? onPressed : null,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 4,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isTaking 
                  ? Colors.white.withOpacity(0.5)
                  : Colors.white,
            ),
            child: isTaking
                ? const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}

// Gallery thumbnail widget
class _GalleryThumbnail extends StatelessWidget {
  final XFile? picture;
  
  const _GalleryThumbnail({this.picture});

  @override
  Widget build(BuildContext context) {
    if (picture == null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
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

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white.withOpacity(0.5),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.file(
            File(picture!.path),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}