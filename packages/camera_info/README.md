# 📷 Camera Info Package

A federated Flutter plugin to retrieve camera hardware information including focal length, field of view, and base optical zoom from native platform APIs.

## 🎯 Features

- ✅ **Get Focal Length** - Retrieve camera focal length in millimeters
- ✅ **Get Field of View** - Retrieve horizontal field of view in degrees  
- ✅ **Calculate Base Zoom** - Automatically calculate base optical zoom relative to wide camera
- ✅ **Multi-Platform** - iOS and Android support via federated plugin architecture
- ✅ **Type Safe** - Full Dart type safety with clear models
- ✅ **Native APIs** - Uses AVFoundation (iOS) and Camera2 API (Android)

## 📦 Package Structure

```
camera_info/
├── camera_info              # Main Dart API
├── platform_interface/      # Platform interface definition
├── ios/                     # iOS implementation (Swift)
└── android/                 # Android implementation (Kotlin)
```

## 🚀 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  camera_info:
    path: ../packages/camera_info
  camera_info_ios:
    path: ../packages/camera_info/ios
  camera_info_android:
    path: ../packages/camera_info/android
```

Then run:

```bash
flutter pub get
```

## 📖 Usage

### Get Properties for All Cameras

```dart
import 'package:camera_info/camera_info.dart';
import 'package:camera/camera.dart';

// Get all available cameras
final cameras = await availableCameras();

// Get hardware properties for all cameras
final allProperties = await CameraInfo.instance.getAllCameraProperties();

for (final camera in cameras) {
  final props = allProperties[camera.name];
  if (props != null) {
    print('Camera: ${camera.name}');
    print('  Focal Length: ${props.focalLength} mm');
    print('  Field of View: ${props.fieldOfView}°');
    print('  Base Zoom: ${props.baseZoom}x');
  }
}
```

### Get Properties for a Specific Camera

```dart
final cameras = await availableCameras();
final backCamera = cameras.first;

final props = await CameraInfo.instance.getCameraProperties(backCamera.name);

print('Focal Length: ${props.focalLength} mm');
print('Field of View: ${props.fieldOfView}°');
print('Sensor Size: ${props.sensorSize}');
```

### Calculate Base Zoom from Field of View

```dart
final allProps = await CameraInfo.instance.getAllCameraProperties();

// Find wide camera as reference (typically ~60-70° FOV)
final wideCamera = allProps.values.firstWhere(
  (p) => p.fieldOfView != null && p.fieldOfView! > 60,
);

// Calculate base zoom for all cameras relative to wide
final baseZooms = <String, double>{};

for (final props in allProps.values) {
  if (props.fieldOfView != null && wideCamera.fieldOfView != null) {
    // Base zoom = wideFOV / cameraFOV
    final baseZoom = wideCamera.fieldOfView! / props.fieldOfView!;
    baseZooms[props.cameraId] = baseZoom;
    
    print('${props.cameraId}: ${baseZoom.toStringAsFixed(2)}x base zoom');
  }
}
```

### Determine Camera Switch Points

```dart
// Get all back cameras sorted by base zoom
final backCameraProps = allProps.values
    .where((p) => p.cameraId.contains('back'))
    .toList()
  ..sort((a, b) {
    final aZoom = calculateBaseZoom(a.fieldOfView, wideFOV);
    final bZoom = calculateBaseZoom(b.fieldOfView, wideFOV);
    return (aZoom ?? 1.0).compareTo(bZoom ?? 1.0);
  });

// Create zoom stops for camera switching
final zoomStops = backCameraProps
    .map((p) => calculateBaseZoom(p.fieldOfView, wideFOV))
    .whereType<double>()
    .toList();

print('Zoom stops: $zoomStops'); // e.g., [0.5, 1.0, 2.0]
```

## 🏗️ Architecture

### Main Package (`camera_info`)

Provides the public API that app developers use:

- `CameraInfo.instance` - Singleton instance
- `getCameraProperties(cameraId)` - Get properties for one camera
- `getAllCameraProperties()` - Get properties for all cameras
- `CameraProperties` - Model class containing camera info

### Platform Interface (`platform_interface`)

Defines the contract that platform implementations must follow:

- `CameraInfoPlatform` - Abstract base class
- `MethodChannelCameraInfo` - Default implementation using method channels

### iOS Implementation (`ios`)

Swift implementation using AVFoundation:

- Retrieves `videoFieldOfView` from `AVCaptureDevice`
- Estimates focal length from FOV
- Discovers all available cameras including ultrawide, wide, and telephoto

### Android Implementation (`android`)

Kotlin implementation using Camera2 API:

- Retrieves `LENS_INFO_AVAILABLE_FOCAL_LENGTHS`
- Calculates FOV from focal length and sensor physical size
- Accesses detailed camera characteristics

## 📊 Data Models

### CameraProperties

```dart
class CameraProperties {
  final String cameraId;          // Camera identifier
  final double? focalLength;      // Focal length in mm
  final double? fieldOfView;      // Horizontal FOV in degrees
  final double? baseZoom;         // Base optical zoom (relative to wide)
  final Size? sensorSize;         // Sensor dimensions
}
```

### Size

```dart
class Size {
  final double width;
  final double height;
}
```

## 🔧 Platform-Specific Notes

### iOS

- Uses `AVCaptureDevice.DiscoverySession` to find cameras
- `videoFieldOfView` is accurate and directly available
- Focal length is estimated (iOS doesn't expose it directly)
- Supports: wide, ultrawide, telephoto, dual, triple cameras

### Android

- Uses `CameraManager` and `CameraCharacteristics`
- Focal length is accurate (directly from hardware)
- FOV is calculated from focal length + sensor physical size
- Some devices may not expose `SENSOR_INFO_PHYSICAL_SIZE`

## 🎯 Use Cases

### Smart Camera Switching

Use base zoom values to determine optimal camera for a given zoom level:

```dart
CameraDescription? findBestCamera(double targetZoom, Map<String, double> baseZooms) {
  // Find camera with base zoom closest to (but not over) target
  for (final camera in cameras) {
    final baseZoom = baseZooms[camera.name] ?? 1.0;
    if (baseZoom <= targetZoom) {
      return camera; // This camera can handle the zoom optically
    }
  }
  return cameras.first; // Fallback
}
```

### Minimize Digital Zoom

```dart
double calculateDigitalZoom(double targetZoom, double baseZoom) {
  // Only apply digital zoom beyond the base optical zoom
  return targetZoom / baseZoom;
}
```

### Camera UI Labels

```dart
String getCameraLabel(CameraProperties props, double wideFOV) {
  final baseZoom = wideFOV / (props.fieldOfView ?? wideFOV);
  
  if (baseZoom < 0.8) return '0.5x Ultrawide';
  if (baseZoom < 1.5) return '1x Wide';
  if (baseZoom < 2.5) return '2x Telephoto';
  return '${baseZoom.toStringAsFixed(1)}x Telephoto';
}
```

## ⚠️ Limitations

- **iOS**: Focal length is estimated (not directly available from AVFoundation)
- **Android**: FOV calculation requires sensor physical size (may not be available on all devices)
- **Accuracy**: Values are hardware-dependent and may have minor variations
- **Base Zoom**: Calculated relative to wide camera, not absolute optical zoom

## 🧪 Testing

Run tests for all packages:

```bash
# Main package
cd camera_info && flutter test

# Platform interface
cd platform_interface && flutter test

# Platform implementations (unit tests)
cd ios && flutter test
cd android && flutter test
```

## 📝 Contributing

When adding new features:

1. Update `CameraInfoPlatform` interface first
2. Implement in both iOS and Android
3. Update main `CameraInfo` API
4. Add tests
5. Update this README

## 📄 License

See LICENSE file in the repository root.

## 🙋 Support

For issues and feature requests, please file an issue in the repository.

