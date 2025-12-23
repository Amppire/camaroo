import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import '../services/camera_service.dart';
import '../widgets/camera_controls.dart';
import '../widgets/camera_overlay.dart';
import 'editor_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameraService = context.read<CameraService>();
    await cameraService.initialize();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final cameraService = context.read<CameraService>();
    if (!cameraService.isInitialized || cameraService.controller == null) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraService.controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _takePicture() async {
    final cameraService = context.read<CameraService>();
    final imagePath = await cameraService.takePicture();
    
    if (imagePath != null && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditorScreen(imagePath: imagePath),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CameraService>(
        builder: (context, cameraService, child) {
          if (cameraService.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    cameraService.error!,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _initializeCamera,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!cameraService.isInitialized || cameraService.controller == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final controller = cameraService.controller!;
          final size = MediaQuery.of(context).size;
          final scale = size.aspectRatio * controller.value.aspectRatio;

          return Stack(
            fit: StackFit.expand,
            children: [
              // Camera preview
              Transform.scale(
                scale: scale < 1 ? 1 / scale : scale,
                child: Center(
                  child: CameraPreview(controller),
                ),
              ),
              
              // Camera overlay (grid, histogram, etc.)
              const CameraOverlay(),
              
              // Camera controls
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: CameraControls(
                  onCapture: _takePicture,
                  onSwitchCamera: () => cameraService.switchCamera(),
                ),
              ),
              
              // Top bar with settings
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.grid_on, color: Colors.white),
                          onPressed: () => cameraService.toggleGrid(),
                        ),
                        IconButton(
                          icon: const Icon(Icons.bar_chart, color: Colors.white),
                          onPressed: () => cameraService.toggleHistogram(),
                        ),
                        IconButton(
                          icon: Icon(
                            cameraService.settings.portraitMode
                                ? Icons.portrait
                                : Icons.photo,
                            color: Colors.white,
                          ),
                          onPressed: () => cameraService.togglePortraitMode(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
