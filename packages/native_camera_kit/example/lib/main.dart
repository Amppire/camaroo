import 'package:flutter/material.dart';
import 'package:native_camera_kit/native_camera_kit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Native Camera Kit Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: const CameraScreen(),
    );
  }
}

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  late NativeCameraController _controller;
  String? _lastPhotoPath;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = NativeCameraController();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      await _controller.initializeDefault();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _controller.pause();
    } else if (state == AppLifecycleState.resumed) {
      _controller.resume();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ValueListenableBuilder<CameraStatus>(
          valueListenable: _controller.status,
          builder: (context, status, _) {
            if (status == CameraStatus.uninitialized || status == CameraStatus.initializing) {
              return const Center(child: CircularProgressIndicator());
            }

            if (status == CameraStatus.error) {
              return Center(
                child: ValueListenableBuilder<String?>(
                  valueListenable: _controller.error,
                  builder: (context, error, _) {
                    return Text(
                      'Error: ${error ?? "Unknown"}',
                      style: const TextStyle(color: Colors.red),
                    );
                  },
                ),
              );
            }

            return Stack(
              children: [
                // Camera preview - full screen with proper aspect ratio
                Positioned.fill(
                  child: Center(
                    child: ValueListenableBuilder<double?>(
                      valueListenable: _controller.aspectRatio,
                      builder: (context, aspectRatio, _) {
                        if (aspectRatio == null) {
                          return const SizedBox.shrink();
                        }
                        
                        return AspectRatio(
                          aspectRatio: aspectRatio,
                          child: NativeCameraPreview(controller: _controller),
                        );
                      },
                    ),
                  ),
                ),

                // Top controls
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Flash toggle
                      IconButton(
                        icon: Icon(_getFlashIcon()),
                        color: Colors.white,
                        iconSize: 32,
                        onPressed: _toggleFlash,
                      ),

                      // Focal length display
                      ValueListenableBuilder<double?>(
                        valueListenable: _controller.focalLength,
                        builder: (context, focal, _) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              '${focal?.toStringAsFixed(1) ?? "?"}mm',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // Focal length slider
                Positioned(
                  bottom: 180,
                  left: 40,
                  right: 40,
                  child: ValueListenableBuilder<double?>(
                    valueListenable: _controller.focalLength,
                    builder: (context, focal, _) {
                      final min = _controller.minFocalLength.value ?? 13.0;
                      final max = _controller.maxFocalLength.value ?? 77.0;
                      final current = focal ?? min;

                      return Slider(
                        value: current.clamp(min, max),
                        min: min,
                        max: max,
                        onChanged: (value) {
                          _controller.setFocalLength(value);
                        },
                      );
                    },
                  ),
                ),

                // Bottom controls
                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Last photo thumbnail
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _lastPhotoPath != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  _lastPhotoPath!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.photo),
                                ),
                              )
                            : const Icon(Icons.photo, color: Colors.white),
                      ),

                      // Capture button
                      GestureDetector(
                        onTap: _takePicture,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Flip camera
                      IconButton(
                        icon: const Icon(Icons.flip_camera_ios),
                        color: Colors.white,
                        iconSize: 40,
                        onPressed: _toggleCamera,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  IconData _getFlashIcon() {
    switch (_controller.flashMode) {
      case FlashMode.off:
        return Icons.flash_off;
      case FlashMode.on:
        return Icons.flash_on;
      case FlashMode.auto:
        return Icons.flash_auto;
      case FlashMode.torch:
        return Icons.flashlight_on;
    }
  }

  void _toggleFlash() {
    final modes = [FlashMode.off, FlashMode.on, FlashMode.auto];
    final currentIndex = modes.indexOf(_controller.flashMode);
    final nextIndex = (currentIndex + 1) % modes.length;
    _controller.setFlashMode(modes[nextIndex]);
    setState(() {});
  }

  Future<void> _toggleCamera() async {
    try {
      await _controller.togglePosition();
    } catch (e) {
      debugPrint('Error toggling camera: $e');
    }
  }

  Future<void> _takePicture() async {
    try {
      final imageData = await _controller.takePicture();
      
      // You can now save the image data to gallery, file system, etc.
      // For now, just show success with data size
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Photo captured: ${imageData.length} bytes')),
        );
      }
    } catch (e) {
      debugPrint('Error taking picture: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }
}
