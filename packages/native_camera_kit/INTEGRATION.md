# Native Camera Kit - Integration Guide

## Quick Start

### 1. Add to your app's `pubspec.yaml`:

```yaml
dependencies:
  native_camera_kit:
    path: ../Packages/native_camera_kit
```

### 2. Update iOS Info.plist

Add camera permissions to `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to take photos</string>
```

### 3. Replace `camera_service.dart`

Instead of using the Flutter `camera` package, use `NativeCameraController`:

```dart
import 'package:native_camera_kit/native_camera_kit.dart';

class CameraModel {
  late NativeCameraController _controller;
  
  CameraModel() {
    _controller = NativeCameraController();
  }

  // Status
  ValueListenable<CameraStatus> get status => _controller.status;
  
  // Focal length (mm)
  ValueListenable<double?> get focalLength => _controller.focalLength;
  ValueListenable<double?> get minFocalLength => _controller.minFocalLength;
  ValueListenable<double?> get maxFocalLength => _controller.maxFocalLength;
  
  // Texture for preview
  ValueListenable<int?> get textureId => _controller.textureId;
  
  // Initialize
  Future<void> initialize() async {
    await _controller.initializeDefault();
  }
  
  // Set focal length (mm)
  Future<void> setFocalLength(double mm) async {
    await _controller.setFocalLength(mm);
  }
  
  // Take picture
  Future<String> takePicture() async {
    return await _controller.takePicture();
  }
  
  // Toggle front/back
  Future<void> toggleCamera() async {
    await _controller.togglePosition();
  }
  
  // Flash
  Future<void> setFlashMode(FlashMode mode) async {
    await _controller.setFlashMode(mode);
  }
  
  // Dispose
  Future<void> dispose() async {
    await _controller.dispose();
  }
}
```

### 4. Update Camera Preview Widget

Replace `CameraPreview` with `NativeCameraPreview`:

```dart
// OLD (Flutter camera package)
CameraPreview(controller)

// NEW (Native Camera Kit)
NativeCameraPreview(controller: nativeCameraController)
```

### 5. Update Zoom Slider

The focal length is now in millimeters (like iOS Camera app):

```dart
ValueListenableBuilder<double?>(
  valueListenable: cameraController.focalLength,
  builder: (context, focal, _) {
    final min = cameraController.minFocalLength.value ?? 13.0;
    final max = cameraController.maxFocalLength.value ?? 77.0;
    final current = focal ?? min;

    return Slider(
      value: current.clamp(min, max),
      min: min,
      max: max,
      label: '${current.toStringAsFixed(0)}mm',
      onChanged: (value) {
        cameraController.setFocalLength(value);
      },
    );
  },
)
```

## Key Differences from Flutter Camera Package

| Feature | Flutter `camera` | Native Camera Kit |
|---------|-----------------|-------------------|
| Camera switching | Slow (reinitializes) | **Instant (seamless)** |
| Zoom control | Digital zoom factor | **Hardware focal length (mm)** |
| Multi-camera | Limited support | **Full iOS camera support** |
| Performance | Good | **Native AVFoundation** |
| Type safety | Method channels | **Pigeon (type-safe)** |

## Benefits

### ✅ Seamless Switching
- No black frames or lag
- Instant camera transitions
- Native iOS behavior

### ✅ Hardware Focal Length
- Measured in millimeters (13mm, 26mm, 52mm, 77mm)
- Matches iOS Camera app behavior
- Accurate optical zoom representation

### ✅ Better Performance
- Native AVFoundation implementation
- No Flutter overhead on camera operations
- Efficient texture rendering

### ✅ Type Safety
- Pigeon-generated code
- Compile-time type checking
- Better IDE support

## Example: Complete Camera Screen

See `native_camera_kit/example/lib/main.dart` for a complete working example with:
- Camera preview
- Focal length slider
- Flash control
- Front/back toggle
- Photo capture
- App lifecycle handling

## Migration Checklist

- [ ] Add `native_camera_kit` to `pubspec.yaml`
- [ ] Update iOS permissions in `Info.plist`
- [ ] Replace `CameraController` with `NativeCameraController`
- [ ] Replace `CameraPreview` with `NativeCameraPreview`
- [ ] Update zoom control to use focal length (mm)
- [ ] Remove old `camera` package dependency
- [ ] Test on physical iOS device
- [ ] Handle app lifecycle (pause/resume)

## Testing

Run the example app:

```bash
cd native_camera_kit/example
flutter run
```

## Troubleshooting

### Camera not showing
- Check iOS permissions are set
- Test on physical device (not simulator)
- Check console for errors

### Black screen on switch
- This shouldn't happen with native camera kit
- If it does, file an issue

### Focal length not changing
- Ensure you're calling `setFocalLength()` not just updating state
- Check min/max range

## Need Help?

See the full example in `native_camera_kit/example/` or check the README.md for API documentation.

