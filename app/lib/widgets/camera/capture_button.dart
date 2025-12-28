// Capture button widget (iOS style)
import 'package:camaroo/core/abstractions/camera_api.dart';
import 'package:flutter/material.dart';
import 'package:native_camera_kit/native_camera_kit.dart' as native_camera_kit;

/// Center camprute button for taking pictures.
class CaptureButton extends StatelessWidget {
  final native_camera_kit.CameraStatus status;
  final VoidCallback onPressed;
  
  const CaptureButton({
    super.key,
    required this.status,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = status == native_camera_kit.CameraStatus.ready;
    final bool isTaking = status == native_camera_kit.CameraStatus.takingPicture;
    
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
                  ? Colors.white.withValues(alpha: 0.5)
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