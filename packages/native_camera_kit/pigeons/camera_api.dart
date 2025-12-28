import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/generated/camera_api.g.dart',
  swiftOut: 'ios/Classes/Generated/CameraApi.g.swift',
  swiftOptions: SwiftOptions(),
  copyrightHeader: 'pigeons/copyright.txt',
))

/// Camera device information
class CameraDevice {
  const CameraDevice({
    required this.id,
    required this.name,
    required this.position,
    required this.focalLength,
    required this.minFocalLength,
    required this.maxFocalLength,
    required this.fieldOfView,
    required this.hasFlash,
  });

  final String id;
  final String name;
  final CameraPosition position;
  final double focalLength;
  final double minFocalLength;
  final double maxFocalLength;
  final double fieldOfView;
  final bool hasFlash;
}

/// Camera position enum
enum CameraPosition {
  back,
  front,
}

/// Flash mode enum
enum FlashMode {
  off,
  on,
  auto,
  torch,
}

/// Camera status enum
enum CameraStatus {
  uninitialized,
  initializing,
  ready,
  takingPicture,
  error,
}

/// Photo capture result
class PhotoResult {
  const PhotoResult({
    required this.data,
    required this.width,
    required this.height,
  });

  final Uint8List data; // Raw JPEG data
  final int width;
  final int height;
}

/// Camera configuration
class CameraConfig {
  const CameraConfig({
    required this.textureId,
    required this.width,
    required this.height,
  });

  final int textureId;
  final int width;
  final int height;
}

/// Camera error
class CameraError {
  const CameraError({
    required this.code,
    required this.message,
  });

  final String code;
  final String message;
}

/// Main camera API - called from Flutter
@HostApi()
abstract class NativeCameraApi {
  /// Get all available cameras
  List<CameraDevice> getAvailableCameras();

  /// Initialize a camera and return texture configuration
  @async
  CameraConfig initializeCamera(String cameraId);

  /// Switch to a different camera seamlessly
  @async
  void switchCamera(String cameraId);

  /// Set focal length in millimeters
  @async
  void setFocalLength(double focalLengthMm);

  /// Set flash mode
  void setFlashMode(FlashMode mode);

  /// Take a picture
  @async
  PhotoResult takePicture();

  /// Dispose camera resources
  void dispose();

  /// Pause camera (app backgrounded)
  void pause();

  /// Resume camera (app foregrounded)
  void resume();
}

/// Flutter API - called from native code for updates
@FlutterApi()
abstract class NativeCameraFlutterApi {
  /// Camera status changed
  void onStatusChanged(CameraStatus status);

  /// Camera error occurred
  void onError(CameraError error);

  /// Focal length changed
  void onFocalLengthChanged(double focalLength);

  /// Available focal length range changed
  void onFocalLengthRangeChanged(double min, double max);
}

