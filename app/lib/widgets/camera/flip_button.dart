import 'dart:ui';
import 'package:camaroo/core/abstractions/camera_api.dart';
import 'package:camaroo/widgets/camera/glass_button.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class FlipButton extends StatelessWidget {
  const FlipButton({
    super.key,
    required this.cameraApi,
    required this.currentCamera,
  });

  final CameraApi cameraApi;
  final CameraDescription currentCamera;

  @override
  Widget build(BuildContext context) {
    return GlassButton(
      onPressed: () => cameraApi.switchCamera(),
      onLongPress: () => _showLensMenu(context),
      child: Icon(_getLensIcon(currentCamera), color: Colors.white, size: 24),
    );
  }

  void _showLensMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Stack(
          children: [
            Positioned(
              bottom: overlay.size.height - position.top + 8,
              right: position.right,
              width: MediaQuery.of(context).size.width / 2.5,
              child: Material(
                color: Colors.transparent,
                child: ScaleTransition(
                  scale: animation,
                  alignment: Alignment.bottomRight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withAlpha(0),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withAlpha(51)),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: cameraApi.cameras.map((camera) {
                            return ListTile(
                              dense: true,
                              visualDensity: const VisualDensity(
                                vertical: -2,
                                horizontal: -4,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              leading: Icon(
                                _getLensIcon(camera),
                                color: currentCamera == camera
                                    ? Colors.amber
                                    : Colors.white,
                                size: 20,
                              ),
                              title: Text(
                                _getLensTypeName(camera),
                                style: TextStyle(
                                  color: currentCamera == camera
                                      ? Colors.amber
                                      : Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              onTap: () {
                                if (camera == currentCamera) {
                                  Navigator.pop(context);
                                  return;
                                }
                                cameraApi.setCurrentCamera(camera);
                                cameraApi.initializeCamera();
                                Navigator.pop(context);
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  IconData _getLensIcon(CameraDescription camera) {
    if (camera.lensDirection == CameraLensDirection.front) {
      return Icons.camera_front;
    } else if (camera.lensDirection == CameraLensDirection.back) {
      if (camera.lensType == CameraLensType.wide) {
        return Icons.camera;
      } else if (camera.lensType == CameraLensType.ultraWide) {
        return Icons.camera;
      } else if (camera.lensType == CameraLensType.telephoto) {
        return Icons.camera;
      } else {
        return Icons.camera_rear;
      }
    } else {
      return Icons.camera_alt;
    }
  }

  String _getLensTypeName(CameraDescription camera) {
    final lensType = camera.lensType;
    final lensDirection = camera.lensDirection;
    return '${lensDirection.name[0].toUpperCase()}${lensDirection.name.substring(1)} ${lensType.name[0].toUpperCase()}${lensType.name.substring(1)}';
  }
}
