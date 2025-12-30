# Native Camera Kit

A native iOS camera plugin for Flutter with seamless camera switching and hardware-level focal length control.

## Features

- ✅ **Seamless Camera Switching**: Instant switching between cameras with no lag or black frames
- ✅ **Hardware Focal Length**: Native iOS focal length control (measured in mm, like the iOS Camera app)
- ✅ **Multiple Cameras**: Support for all iOS camera types (Wide, Ultra Wide, Telephoto, TrueDepth)
- ✅ **High Performance**: Native AVFoundation implementation for optimal performance
- ✅ **Type-Safe**: Uses Pigeon for type-safe communication between Flutter and iOS
- ✅ **Full Flash Control**: Off, On, Auto, and Torch modes

## Platform Support

| Platform | Supported |
|----------|-----------|
| iOS      | ✅        |
| Android  | ❌ (Coming soon) |
| Web      | ❌        |
| macOS    | ❌        |
| Windows  | ❌        |
| Linux    | ❌        |

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  native_camera_kit:
    path: ../Packages/native_camera_kit
```

## iOS Setup

Add camera permissions to your `Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to take photos</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs photo library access to save photos</string>
```

## Usage

### Basic Example

```dart
import 'package:native_camera_kit/native_camera_kit.dart';

class CameraScreen extends StatefulWidget {
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late NativeCameraController _controller;

  @override
  void initState() {
    super.initState();
    _controller = NativeCameraController();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      await _controller.initializeDefault();
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<CameraStatus>(
        valueListenable: _controller.status,
        builder: (context, status, _) {
          if (status != CameraStatus.ready) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              // Camera preview
              NativeCameraPreview(controller: _controller),
              
              // Controls
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Toggle camera
                    IconButton(
                      icon: const Icon(Icons.flip_camera_ios),
                      onPressed: () => _controller.togglePosition(),
                    ),
                    
                    // Capture button
                    FloatingActionButton(
                      onPressed: () async {
                        final path = await _controller.takePicture();
                        print('Photo saved to: $path');
                      },
                      child: const Icon(Icons.camera),
                    ),
                    
                    // Flash toggle
                    IconButton(
                      icon: const Icon(Icons.flash_on),
                      onPressed: () {
                        _controller.setFlashMode(
                          _controller.flashMode == FlashMode.off
                              ? FlashMode.on
                              : FlashMode.off,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

### Advanced: Focal Length Control

```dart
// Get all cameras
final cameras = await controller.getAvailableCameras();

// Find telephoto camera
final telephoto = cameras.firstWhere(
  (c) => c.focalLength > 50.0,
);

// Switch to telephoto
await controller.switchCamera(telephoto);

// Or set focal length directly (will auto-switch if needed)
await controller.setFocalLength(52.0); // 52mm focal length
```

### Focal Length Slider (iOS-style)

```dart
ValueListenableBuilder<double?>(
  valueListenable: controller.focalLength,
  builder: (context, focal, _) {
    return Slider(
      value: focal ?? 26.0,
      min: controller.minFocalLength.value ?? 13.0,
      max: controller.maxFocalLength.value ?? 77.0,
      onChanged: (value) {
        controller.setFocalLength(value);
      },
    );
  },
)
```

## API Reference

### NativeCameraController

#### Properties
- `status`: ValueListenable<CameraStatus> - Current camera status
- `focalLength`: ValueListenable<double?> - Current focal length (mm)
- `minFocalLength`: ValueListenable<double?> - Minimum focal length (mm)
- `maxFocalLength`: ValueListenable<double?> - Maximum focal length (mm)
- `availableCameras`: List<CameraDevice>? - All available cameras
- `currentCamera`: CameraDevice? - Currently active camera
- `flashMode`: FlashMode - Current flash mode

#### Methods
- `Future<List<CameraDevice>> getAvailableCameras()` - Get all cameras
- `Future<void> initialize(CameraDevice camera)` - Initialize specific camera
- `Future<void> initializeDefault()` - Initialize default back camera
- `Future<void> switchCamera(CameraDevice camera)` - Switch cameras seamlessly
- `Future<void> togglePosition()` - Toggle between front/back
- `Future<void> setFocalLength(double mm)` - Set focal length in mm
- `Future<void> setFlashMode(FlashMode mode)` - Set flash mode
- `Future<String> takePicture()` - Take picture, returns file path
- `Future<void> dispose()` - Clean up resources

### CameraDevice

Properties:
- `id`: String - Unique camera identifier
- `name`: String - Human-readable name
- `position`: CameraPosition - Front or back
- `focalLength`: double - Base focal length (mm)
- `minFocalLength`: double - Min focal length (mm)
- `maxFocalLength`: double - Max focal length (mm)
- `fieldOfView`: double - Field of view (degrees)
- `hasFlash`: bool - Whether flash is available

### Enums

#### CameraPosition
- `back` - Rear-facing camera
- `front` - Front-facing camera

#### FlashMode
- `off` - Flash off
- `on` - Flash on
- `auto` - Auto flash
- `torch` - Torch mode (continuous light)

#### CameraStatus
- `uninitialized` - Not initialized
- `initializing` - Initializing
- `ready` - Ready to use
- `takingPicture` - Capturing photo
- `error` - Error state

## How It Works

### Seamless Switching
Unlike the standard Flutter `camera` plugin which reinitializes the entire camera session on switch (causing lag), this plugin uses AVFoundation's session reconfiguration:

```swift
session.beginConfiguration()
session.removeInput(oldInput)
session.addInput(newInput)
session.commitConfiguration()
```

This provides instant, seamless camera switching with zero lag.

### Hardware Focal Length
The plugin exposes the actual hardware focal length from iOS devices, measured in millimeters:
- Ultra Wide: ~13mm
- Wide: ~26mm
- Telephoto: ~52mm, ~77mm, etc.

This allows for precise zoom control and seamless switching between optical lenses based on the target focal length.

## Development

### Regenerating Pigeon Code

If you modify `pigeons/camera_api.dart`:

```bash
cd native_camera_kit
dart run pigeon --input pigeons/camera_api.dart
```

This generates:
- `lib/src/generated/camera_api.g.dart` (Dart)
- `ios/Classes/Generated/CameraApi.g.swift` (Swift)

## License

See LICENSE file.
