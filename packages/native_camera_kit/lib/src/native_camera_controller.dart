import 'dart:async';
import 'package:flutter/foundation.dart';
import 'generated/camera_api.g.dart';

/// Native Camera Controller
/// 
/// Manages the native camera with seamless switching and focal length control
class NativeCameraController implements NativeCameraFlutterApi {
  NativeCameraController() {
    _api = NativeCameraApi();
    NativeCameraFlutterApi.setUp(this);
  }

  late final NativeCameraApi _api;

  // State notifiers
  final ValueNotifier<CameraStatus> _statusNotifier = ValueNotifier(CameraStatus.uninitialized);
  final ValueNotifier<String?> _errorNotifier = ValueNotifier(null);
  final ValueNotifier<double?> _focalLengthNotifier = ValueNotifier(null);
  final ValueNotifier<double?> _minFocalLengthNotifier = ValueNotifier(null);
  final ValueNotifier<double?> _maxFocalLengthNotifier = ValueNotifier(null);
  final ValueNotifier<int?> _textureIdNotifier = ValueNotifier(null);
  final ValueNotifier<double?> _aspectRatioNotifier = ValueNotifier(null);

  // Current state
  List<CameraDevice>? _availableCameras;
  CameraDevice? _currentCamera;
  FlashMode _flashMode = FlashMode.off;

  // Public getters
  ValueListenable<CameraStatus> get status => _statusNotifier;
  ValueListenable<String?> get error => _errorNotifier;
  ValueListenable<double?> get focalLength => _focalLengthNotifier;
  ValueListenable<double?> get minFocalLength => _minFocalLengthNotifier;
  ValueListenable<double?> get maxFocalLength => _maxFocalLengthNotifier;
  ValueListenable<int?> get textureId => _textureIdNotifier;
  ValueListenable<double?> get aspectRatio => _aspectRatioNotifier;
  
  List<CameraDevice>? get availableCameras => _availableCameras;
  CameraDevice? get currentCamera => _currentCamera;
  FlashMode get flashMode => _flashMode;

  bool get isInitialized => _statusNotifier.value == CameraStatus.ready;

  // MARK: - Public API

  /// Get all available cameras
  Future<List<CameraDevice>> getAvailableCameras() async {
    try {
      _availableCameras = await _api.getAvailableCameras();
      return _availableCameras!;
    } catch (e) {
      _errorNotifier.value = 'Failed to get cameras: $e';
      rethrow;
    }
  }

  /// Initialize camera with a specific device
  Future<void> initialize(CameraDevice camera) async {
    try {
      _currentCamera = camera;
      _statusNotifier.value = CameraStatus.initializing;
      
      final config = await _api.initializeCamera(camera.id);
      
      _textureIdNotifier.value = config.textureId.toInt();
      _focalLengthNotifier.value = camera.focalLength;
      _minFocalLengthNotifier.value = camera.minFocalLength;
      _maxFocalLengthNotifier.value = camera.maxFocalLength;
      
      // Calculate aspect ratio from camera dimensions
      // Camera outputs in landscape, so width/height gives us the ratio
      _aspectRatioNotifier.value = config.width.toDouble() / config.height.toDouble();
      
      _statusNotifier.value = CameraStatus.ready;
    } catch (e) {
      _errorNotifier.value = 'Failed to initialize: $e';
      _statusNotifier.value = CameraStatus.error;
      rethrow;
    }
  }

  /// Initialize with the default back camera (ultra-wide - lowest focal length)
  Future<void> initializeDefault() async {
    final cameras = await getAvailableCameras();
    
    // Find back cameras and sort by focal length (lowest first)
    final backCameras = cameras.where((c) => c.position == CameraPosition.back).toList();
    
    if (backCameras.isEmpty) {
      // Fallback to first available camera
      await initialize(cameras.first);
      return;
    }
    
    // Sort by focal length (ascending) to get ultra-wide first
    backCameras.sort((a, b) => a.focalLength.compareTo(b.focalLength));
    
    // Initialize with ultra-wide (lowest focal length)
    await initialize(backCameras.first);
  }

  /// Switch to a different camera seamlessly
  Future<void> switchCamera(CameraDevice camera) async {
    try {
      await _api.switchCamera(camera.id);
      _currentCamera = camera;
    } catch (e) {
      _errorNotifier.value = 'Failed to switch camera: $e';
      rethrow;
    }
  }

  /// Switch between front and back cameras
  Future<void> togglePosition() async {
    if (_availableCameras == null || _currentCamera == null) {
      return;
    }

    final targetPosition = _currentCamera!.position == CameraPosition.back
        ? CameraPosition.front
        : CameraPosition.back;

    final targetCamera = _availableCameras!.firstWhere(
      (c) => c.position == targetPosition,
      orElse: () => _currentCamera!,
    );

    if (targetCamera != _currentCamera) {
      await switchCamera(targetCamera);
    }
  }

  /// Set focal length in millimeters (iOS-style zoom)
  Future<void> setFocalLength(double focalLengthMm) async {
    try {
      await _api.setFocalLength(focalLengthMm);
    } catch (e) {
      _errorNotifier.value = 'Failed to set focal length: $e';
      rethrow;
    }
  }

  /// Set flash mode
  Future<void> setFlashMode(FlashMode mode) async {
    try {
      await _api.setFlashMode(mode);
      _flashMode = mode;
    } catch (e) {
      _errorNotifier.value = 'Failed to set flash mode: $e';
      rethrow;
    }
  }

  /// Take a picture and return raw JPEG data
  Future<Uint8List> takePicture() async {
    try {
      final result = await _api.takePicture();
      return result.data;
    } catch (e) {
      _errorNotifier.value = 'Failed to take picture: $e';
      rethrow;
    }
  }

  /// Pause camera (e.g., when app goes to background)
  Future<void> pause() async {
    try {
      await _api.pause();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to pause camera: $e');
      }
    }
  }

  /// Resume camera (e.g., when app comes to foreground)
  Future<void> resume() async {
    try {
      await _api.resume();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to resume camera: $e');
      }
    }
  }

  /// Dispose resources
  Future<void> dispose() async {
    try {
      await _api.dispose();
      _statusNotifier.value = CameraStatus.uninitialized;
      _textureIdNotifier.value = null;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to dispose camera: $e');
      }
    }
  }

  // MARK: - NativeCameraFlutterApi Implementation

  @override
  void onStatusChanged(CameraStatus status) {
    _statusNotifier.value = status;
  }

  @override
  void onError(CameraError error) {
    _errorNotifier.value = '${error.code}: ${error.message}';
  }

  @override
  void onFocalLengthChanged(double focalLength) {
    _focalLengthNotifier.value = focalLength;
  }

  @override
  void onFocalLengthRangeChanged(double min, double max) {
    _minFocalLengthNotifier.value = min;
    _maxFocalLengthNotifier.value = max;
  }
}

