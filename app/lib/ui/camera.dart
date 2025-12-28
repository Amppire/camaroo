import 'dart:ui';
import 'package:camaroo/utils/theme_constants.dart';
import 'package:camaroo/widgets/camera/glass_button.dart';
import 'package:camaroo/widgets/camera/capture_button.dart';
import 'package:camaroo/widgets/camera/viewfinder.dart';
import 'package:camaroo/widgets/camera/gallery_thumbnail.dart';
import 'package:camaroo/widgets/camera/flip_button.dart';
import 'package:camaroo/adapters/camera_adapter.dart';
import 'package:camaroo/core/abstractions/camera_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:native_camera_kit/native_camera_kit.dart' as native_camera_kit;

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
    widget.cameraAdapter.statusNotifier.value = native_camera_kit.CameraStatus.uninitialized;
    widget.cameraAdapter.errorMessageNotifier.value = null;
    widget.cameraAdapter.flashModeNotifier.value = native_camera_kit.FlashMode.off;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeConstants.backgroundColor,
      body: ValueListenableBuilder<native_camera_kit.CameraStatus>(
        valueListenable: widget.cameraAdapter.statusNotifier,
        builder: (context, status, _) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // Camera Preview (full screen)
              Viewfinder(
                cameraApi: widget.cameraApi,
                cameraAdapter: widget.cameraAdapter,
                status: status,
              ),

              // Top controls overlay
              Positioned(top: 0, left: 0, right: 0, child: _buildTopControls()),

              Positioned(top: 0, left: 0, right: 0, child: _buildTopControls()),

              // Bottom controls overlay
              Positioned(bottom: 0, left: 0, right: 0, child: _buildBottomControls(status)),

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

  Widget _buildTopControls() {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Flash control
            ValueListenableBuilder<native_camera_kit.FlashMode?>(
              valueListenable: widget.cameraAdapter.flashModeNotifier,
              builder: (context, native_camera_kit.FlashMode? flashMode, _) {
                return GlassButton(
                  onPressed: () => widget.cameraApi.toggleFlash(),
                  onLongPress: () => {},
                  child: Icon(_getFlashIcon( native_camera_kit.FlashMode.off), color: ThemeConstants.textAndIconColor, size: 24),
                );
              },
            ),

            // Close button (optional)
            GlassButton(
              onPressed: () {
                // TODO: Implement settings pop-up.
              },
              child: const Icon(Icons.menu_rounded, color: ThemeConstants.textAndIconColor, size: 24),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls(native_camera_kit.CameraStatus status) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Gallery thumbnail
            ValueListenableBuilder<String?>(
              valueListenable: widget.cameraAdapter.errorMessageNotifier,
              builder: (context, error, _) {
                if (error == null) return const SizedBox.shrink();
                return const SizedBox(width: 56);
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
                color: ThemeConstants.errorColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ThemeConstants.errorColor.withValues(alpha: 0.3), width: 1),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: ThemeConstants.textAndIconColor, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      error,
                      style: const TextStyle(
                        color: ThemeConstants.textAndIconColor,
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

  IconData _getFlashIcon(native_camera_kit.FlashMode? mode) {
    switch (mode) {
      case native_camera_kit.FlashMode.off:
        return Icons.flash_off;
      case native_camera_kit.FlashMode.auto:
        return Icons.flash_auto;
      case native_camera_kit.FlashMode.on:
        return Icons.flash_on;
      case native_camera_kit.FlashMode.torch:
        return Icons.flashlight_on;
      case null:
        return Icons.flash_off;
    }
  }
}
