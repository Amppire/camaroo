import 'package:camaroo/utils/app_constants.dart';
import 'package:camera/camera.dart';
import 'package:camaroo/core/abstractions/camera_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:storage/storage.dart';
import 'package:camera_info/camera_info.dart';

class CameraApiModel implements CameraApi {
  CameraApiModel({required StorageService storageService}) : _storageService = storageService;

  final StorageService _storageService;

  CameraStatus _cameraStatus = CameraStatus.uninitialized;
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  CameraDescription? _currentCamera;
  double? _zoomLevel;
  double? _minZoomLevel;
  double? _maxZoomLevel;
  String? _errorMessage;
  FlashMode? _flashMode = FlashMode.off;
  XFile? _pictureTaken;
  
  // Focal length (mm) - iOS-style
  double? _focalLength;
  double? _minFocalLength;
  double? _maxFocalLength;
  List<double> _focalLengthStops = [];
  

  // Store camera hardware properties
  final Map<String, CameraProperties> _cameraProperties = {};
  

  @override
  CameraStatus get status => _cameraStatus;

  @override
  Function(CameraStatus) onStatusChanged = (status) {};

  @override
  void setStatus(CameraStatus newStatus) {
    _cameraStatus = newStatus;
    onStatusChanged(newStatus);
  }

  // Cameras
  @override
  List<CameraDescription> get cameras => _cameras;

  @override
  Function(List<CameraDescription>) onCamerasChanged = (cameras) {};

  @override
  void setCameras(List<CameraDescription> newCameras) {
    _cameras = newCameras;
    onCamerasChanged(newCameras);
  }

  // Camera Controller
  @override
  CameraController? get cameraController => _cameraController;

  @override
  Function(CameraController?) onCameraControllerChanged = (cameraController) {};

  @override
  void setCameraController(CameraController? newCameraController) {
    _cameraController = newCameraController;
    onCameraControllerChanged(newCameraController);
  }

  // Current Camera
  @override
  CameraDescription? get currentCamera => _currentCamera;

  @override
  Function(CameraDescription?) onCurrentCameraChanged = (currentCamera) {};

  @override
  void setCurrentCamera(CameraDescription? newCurrentCamera) {
    _currentCamera = newCurrentCamera;
    onCurrentCameraChanged(newCurrentCamera);
  }

  // Flash Mode
  @override
  FlashMode? get flashMode => _flashMode;

  @override
  Function(FlashMode?) onFlashModeChanged = (flashMode) {};

  @override
  void setFlashMode(FlashMode? newFlashMode) {
    _flashMode = newFlashMode;
    onFlashModeChanged(newFlashMode);
    // Apply flash mode to controller
    _applyFlashMode();
  }

  // Zoom Level
  @override
  double? get zoomLevel => _zoomLevel;

  @override
  Function(double?) onZoomLevelChanged = (zoomLevel) {};

  @override
  void setZoomLevel(double? newZoomLevel) {
    _zoomLevel = newZoomLevel;
    onZoomLevelChanged(newZoomLevel);
  }


  // Min/Max Zoom Levels
  @override
  double? get minZoomLevel => _minZoomLevel;
  @override
  double? get maxZoomLevel => _maxZoomLevel;
  @override
  Function(double, double) onZoomRangeChanged = (min, max) {};
  @override
  void setZoomRange(double min, double max) {
    _minZoomLevel = min;
    _maxZoomLevel = max;
    onZoomRangeChanged(min, max);
  }

  // Focal Length (mm) - iOS-style
  @override
  double? get focalLength => _focalLength;
  
  @override
  Function(double?) onFocalLengthChanged = (focalLength) {};
  
  // Internal helper to update focal length state
  void _updateFocalLengthState(double? newFocalLength) {
    _focalLength = newFocalLength;
    onFocalLengthChanged(newFocalLength);
  }

  // Min/Max Focal Lengths (mm)
  @override
  double? get minFocalLength => _minFocalLength;
  
  @override
  double? get maxFocalLength => _maxFocalLength;
  
  @override
  Function(double, double) onFocalLengthRangeChanged = (min, max) {};
  
  @override
  void setFocalLengthRange(double min, double max) {
    _minFocalLength = min;
    _maxFocalLength = max;
    onFocalLengthRangeChanged(min, max);
  }

  // Focal Length Stops (mm)
  @override
  List<double> get focalLengthStops => _focalLengthStops;
  
  @override
  Function(List<double>) onFocalLengthStopsChanged = (stops) {};
  
  @override
  void setFocalLengthStops(List<double> stops) {
    _focalLengthStops = stops;
    onFocalLengthStopsChanged(stops);
  }

  // Error Message
  @override
  String? get errorMessage => _errorMessage;

  @override
  Function(String?) onErrorMessageChanged = (errorMessage) {};

  @override
  void setErrorMessage(String? newErrorMessage) {
    _errorMessage = newErrorMessage;
    onErrorMessageChanged(newErrorMessage);
  }

  @override
  XFile? get pictureTaken => _pictureTaken;

  @override
  Function(XFile?) onPictureTakenChanged = (pictureTaken) {};

  @override
  void setPictureTaken(XFile? newPictureTaken) {
    _pictureTaken = newPictureTaken;
    onPictureTakenChanged(newPictureTaken);
  }

  // ============================================================================
  // PUBLIC METHODS
  // ============================================================================

@override
Future<void> initializeCamera() async {
  // Validation: Don't re-initialize if already initializing
  if (status == CameraStatus.initializing) {
    return;
  }


  // Update state
  setStatus(CameraStatus.initializing);
  setErrorMessage(null);

  try {
    // Get available cameras if not already loaded
    if (_cameras.isEmpty) {
      _cameras = await availableCameras();
      _cameras.sort(
        (a, b) => a.lensDirection.name.compareTo(b.lensDirection.name),
      );
      onCamerasChanged(_cameras);
      _currentCamera = _cameras.first;
      onCurrentCameraChanged(_currentCamera);
    }
        // ⭐ Load camera properties FIRST (before anything else)
    if (_cameraProperties.isEmpty) {
      await _loadCameraProperties();
    }



    // Business rule: Must have at least one camera
    if (_cameras.isEmpty) {
      setErrorMessage(AppConstants.noCamerasFound);
      setStatus(CameraStatus.error);
      return;
    }

    // Dispose old controller if exists
    await _cameraController?.dispose();

    // Create new controller with current camera
    final camera = _currentCamera;
    if (camera == null) {
      setErrorMessage(AppConstants.noCameraSelected);
      setStatus(CameraStatus.error);
      return;
    }

    final controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // Initialize the controller
    await controller.initialize();

    // Lock capture orientation to portrait
    await controller.lockCaptureOrientation(DeviceOrientation.portraitUp);

    // Set flash mode
    await controller.setFlashMode(_flashMode ?? FlashMode.off);

    // ⭐ FETCH AND SET ZOOM RANGE
    final minZoom = await controller.getMinZoomLevel();
    final maxZoom = await controller.getMaxZoomLevel();
    setZoomRange(minZoom, maxZoom);
    
    // Set initial focal length to camera's base focal length
    final props = _cameraProperties[camera.name];
    if (props?.focalLength != null) {
      _updateFocalLengthState(props!.focalLength);
      // Also set zoom level for backward compatibility
      final wideFocalLength = _getWideCameraFocalLength();
      if (wideFocalLength != null) {
        final zoomRatio = props.focalLength! / wideFocalLength;
        setZoomLevel(zoomRatio);
      }
    } else {
      setZoomLevel(1.0); // Fallback
    }

    // Update state
    setCameraController(controller);
    setStatus(CameraStatus.ready);
  } on CameraException catch (e) {
    setErrorMessage('${AppConstants.cameraNotReady} ${e.description}');
    setStatus(CameraStatus.error);
  } catch (e) {
    setErrorMessage('${AppConstants.unexpectedError} $e');
    setStatus(CameraStatus.error);
  }
}

  @override
Future<void> switchCamera() async {
  // Business rule: Can't switch if only one camera
  if (cameras.length <= 1) {
    setErrorMessage(AppConstants.onlyOneCameraAvailable);
    return;
  }

  // Business rule: Can't switch while taking picture
  if (status == CameraStatus.takingPicture) {
    setErrorMessage(AppConstants.cannotSwitchWhileTakingPicture);
    return;
  }

  // Switch between front camera and main rear camera
  for (final camera in cameras) {
    final currentCamera = _currentCamera!;
    if (camera != _currentCamera &&
        camera.lensDirection != currentCamera.lensDirection) {
      setCurrentCamera(camera);
      break;
    }
  }

  // Re-initialize with new camera (this will also update zoom range)
  await initializeCamera();
}


  @override
  Future<void> takePicture() async {
    // Business rules: Camera must be ready
    if (status != CameraStatus.ready) {
      setErrorMessage(AppConstants.cameraNotReady);
      return;
    }

    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      setErrorMessage(AppConstants.cameraControllerNotInitialized);
      return;
    }

    setStatus(CameraStatus.takingPicture);
    setErrorMessage(null);

    try {
      final XFile picture = await _cameraController!.takePicture();
      setPictureTaken(picture);

      final photo = Photo(id: picture.path, filePath: picture.path, capturedAt: DateTime.now());
      await _storageService.photos.savePhoto(photo);
      setStatus(CameraStatus.ready);
    } on CameraException catch (e) {
      setErrorMessage('${AppConstants.failedToTakePicture} ${e.description}');
      setStatus(CameraStatus.ready);
    } catch (e) {
      setErrorMessage('${AppConstants.unexpectedError} $e');
      setStatus(CameraStatus.ready);
    }
  }

  @override
  Future<void> toggleFlash() async {
    // Pure business logic - cycle through flash modes
    FlashMode newMode;
    switch (flashMode) {
      case FlashMode.off:
        newMode = FlashMode.auto;
        break;
      case FlashMode.auto:
        newMode = FlashMode.always;
        break;
      case FlashMode.always:
        newMode = FlashMode.torch;
        break;
      case FlashMode.torch:
        newMode = FlashMode.off;
        break;
      case null:
        newMode = FlashMode.auto;
        break;
    }

    setFlashMode(newMode);
  }

  // Add this method to CameraApiModel class

/// Set zoom level (deprecated - use setFocalLength instead)
@override
Future<void> setZoom(double zoom) async {
  // Convert zoom to focal length and use setFocalLength
  final wideFocalLength = _getWideCameraFocalLength();
  if (wideFocalLength != null) {
    final focalLengthMm = wideFocalLength * zoom;
    await setFocalLength(focalLengthMm);
  }
}

/// Set focal length in millimeters (iOS-style)
@override
Future<void> setFocalLength(double focalLengthMm) async {
  if (_cameraController == null || !_cameraController!.value.isInitialized) {
    return;
  }

  try {
    // Clamp to valid range
    final minFocal = _minFocalLength ?? 2.0;
    final maxFocal = _maxFocalLength ?? 200.0;
    final clampedFocalLength = focalLengthMm.clamp(minFocal, maxFocal);
    
    // Update camera based on focal length
    await _updateCameraForFocalLength(clampedFocalLength);
    
  } catch (e) {
    if (kDebugMode) {
      print('Error setting focal length: $e');
    }
  }
}

/// Update camera based on focal length (mm) - iOS-style
Future<void> _updateCameraForFocalLength(double targetFocalLengthMm) async {
  final currentCamera = _currentCamera;
  if (currentCamera == null) {
    return;
  }

  try {
    if (kDebugMode) {
      print('🎯 Setting focal length: ${targetFocalLengthMm.toStringAsFixed(1)}mm');
    }
    
    // Step 1: Find best camera for target focal length
    final bestCamera = _findBestCameraForEffectiveFocalLength(targetFocalLengthMm);
    
    if (bestCamera == null) {
      if (kDebugMode) {
        print('⚠️ No suitable camera found');
      }
      return;
    }
    
    final bestProps = _cameraProperties[bestCamera.name];
    final bestBaseFocalLength = bestProps?.focalLength;
    
    if (bestBaseFocalLength == null || bestBaseFocalLength <= 0) {
      if (kDebugMode) {
        print('⚠️ Best camera focal length not available');
      }
      return;
    }
    
    // Step 2: Check if we need to switch cameras
    final needsSwitch = bestCamera != currentCamera;
    
    if (needsSwitch) {
      if (kDebugMode) {
        print('🔄 Switching cameras');
        print('   From: ${currentCamera.name}');
        print('   To: ${bestCamera.name} (${bestBaseFocalLength.toStringAsFixed(1)}mm base)');
      }
      
      // Switch to best camera
      await _switchToCamera(bestCamera);
      
      // Ensure controller is ready
      if (_cameraController == null || !_cameraController!.value.isInitialized) {
        return;
      }
    }
    
    // Step 3: Calculate digital zoom for the selected camera
    // Digital zoom = target focal length / camera base focal length
    final requiredDigitalZoom = targetFocalLengthMm / bestBaseFocalLength;
    
    // Get camera's digital zoom range
    final minDigital = await _cameraController!.getMinZoomLevel();
    final maxDigital = await _cameraController!.getMaxZoomLevel();
    
    // Clamp digital zoom to camera's range
    final clampedDigitalZoom = requiredDigitalZoom.clamp(minDigital, maxDigital);
    
    if (kDebugMode) {
      print('📊 Digital zoom calculation:');
      print('   Target: ${targetFocalLengthMm.toStringAsFixed(1)}mm');
      print('   Camera base: ${bestBaseFocalLength.toStringAsFixed(1)}mm');
      print('   Required digital: ${requiredDigitalZoom.toStringAsFixed(2)}x');
      print('   Clamped digital: ${clampedDigitalZoom.toStringAsFixed(2)}x');
    }
    
    // Step 4: Apply zoom
    // When switching cameras, the new camera starts at its base focal length (1.0x digital zoom)
    // Then we apply the required digital zoom to reach the target focal length
    await _cameraController!.setZoomLevel(clampedDigitalZoom);
    
    // Update state
    _updateFocalLengthState(targetFocalLengthMm);
    
    // Also update zoom level for backward compatibility
    final wideFocalLength = _getWideCameraFocalLength();
    if (wideFocalLength != null) {
      final zoomRatio = targetFocalLengthMm / wideFocalLength;
      setZoomLevel(zoomRatio);
    }
    
    if (kDebugMode) {
      print('✅ Applied: ${targetFocalLengthMm.toStringAsFixed(1)}mm → ${bestCamera.name} @ ${clampedDigitalZoom.toStringAsFixed(2)}x digital');
    }
    
  } catch (e) {
    if (kDebugMode) {
      print('❌ Error updating camera: $e');
    }
  }
}





Future<void> _loadCameraProperties() async {
  try {
    if (kDebugMode) {
      print('🔍 Loading camera hardware properties...');
    }
    
    final allProps = await CameraInfo.instance.getAllCameraProperties();
    
    if (kDebugMode) {
      print('📋 Found ${allProps.length} cameras from camera_info');
      print('📋 Available camera IDs: ${allProps.keys.toList()}');
    }

    // Store properties for each camera
    for (final camera in _cameras) {
      // Try exact match first
      var props = allProps[camera.name];
      
      // If no exact match, try fuzzy matching
      if (props == null) {
        try {
          props = allProps.values.firstWhere(
            (p) => p.cameraId.contains(camera.name.split(':').last) ||
                   camera.name.contains(p.cameraId.split(':').last),
          );
        } catch (e) {
          // No match found, skip this camera
          if (kDebugMode) {
            print('⚠️ No properties found for camera: ${camera.name}');
          }
          continue;
        }
      }

        _cameraProperties[camera.name] = props;
        
        if (kDebugMode) {
          print('✅ ${camera.name} (${camera.lensType}):');
          print('   Focal Length: ${props.focalLength?.toStringAsFixed(2) ?? "N/A"} mm');
          print('   FOV: ${props.fieldOfView?.toStringAsFixed(2) ?? "N/A"}°');
        }
      
    }
    
    // Calculate focal length stops and range
    _calculateFocalLengthStops();
    
    // Debug: Print what we stored
    if (kDebugMode) {
      print('\n📊 Stored ${_cameraProperties.length} camera properties');
      for (final entry in _cameraProperties.entries) {
        print('   ${entry.key}: FL=${entry.value.focalLength?.toStringAsFixed(2) ?? "N/A"}mm');
      }
      print('📍 Focal length stops: $_focalLengthStops');
      print('📏 Focal length range: ${_minFocalLength?.toStringAsFixed(1) ?? "N/A"}mm - ${_maxFocalLength?.toStringAsFixed(1) ?? "N/A"}mm');
    }
    
  } catch (e) {
    if (kDebugMode) {
      print('❌ Error loading camera properties: $e');
    }
  }
}

/// Calculate focal length stops (camera switch points in mm)
void _calculateFocalLengthStops() {
  final backCameras = _cameras
      .where((c) => c.lensDirection == CameraLensDirection.back)
      .toList();
  
  // Get base focal lengths for all back cameras
  final focalLengths = <double>[];
  double? minFocal;
  double? maxFocal;
  
  for (final camera in backCameras) {
    final props = _cameraProperties[camera.name];
    final focalLength = props?.focalLength;
    
    if (focalLength != null && focalLength > 0) {
      focalLengths.add(focalLength);
      
      if (minFocal == null || focalLength < minFocal) {
        minFocal = focalLength;
      }
      
      // Calculate max focal length (base focal length × max digital zoom)
      // Estimate max digital zoom as 10x (typical for most cameras)
      final estimatedMaxFocal = focalLength * 10.0;
      if (maxFocal == null || estimatedMaxFocal > maxFocal) {
        maxFocal = estimatedMaxFocal;
      }
    }
  }
  
  // Sort focal lengths
  focalLengths.sort();
  
  // Set stops (base focal lengths of each camera)
  setFocalLengthStops(focalLengths);
  
  // Set range
  if (minFocal != null && maxFocal != null) {
    setFocalLengthRange(minFocal, maxFocal);
  }
}

/// Get wide camera focal length (reference for zoom calculations)
double? _getWideCameraFocalLength() {
  // Find wide camera
  for (final camera in _cameras) {
    if (camera.lensType == CameraLensType.wide && 
        camera.lensDirection == CameraLensDirection.back) {
      final props = _cameraProperties[camera.name];
      return props?.focalLength;
    }
  }
  
  // Fallback: use shortest focal length
  double? shortest;
  for (final props in _cameraProperties.values) {
    if (props.focalLength != null && props.focalLength! > 0) {
      if (shortest == null || props.focalLength! < shortest) {
        shortest = props.focalLength;
      }
    }
  }
  
  return shortest;
}

/// Switch to a specific camera seamlessly
Future<void> _switchToCamera(CameraDescription camera) async {
  if (camera == _currentCamera) return;
  
  if (kDebugMode) {
    print('🔄 Switching to: ${camera.name}');
  }
  
  // Dispose old controller
  await _cameraController?.dispose();
  
  // Create new controller
  final controller = CameraController(
    camera,
    ResolutionPreset.high,
    enableAudio: false,
    imageFormatGroup: ImageFormatGroup.jpeg,
  );
  
  try {
    await controller.initialize();
    await controller.lockCaptureOrientation(DeviceOrientation.portraitUp);
    await controller.setFlashMode(_flashMode ?? FlashMode.off);
    
    // Update state
    setCurrentCamera(camera);
    setCameraController(controller);
    
    // Update zoom range for new camera
    final minZoom = await controller.getMinZoomLevel();
    final maxZoom = await controller.getMaxZoomLevel();
    setZoomRange(minZoom, maxZoom);
    
    // Reset zoom to camera's base focal length (1.0x digital zoom)
    final props = _cameraProperties[camera.name];
    if (props?.focalLength != null) {
      await controller.setZoomLevel(1.0);
      _updateFocalLengthState(props!.focalLength);
      
      // Also update zoom level for compatibility
      final wideFocalLength = _getWideCameraFocalLength();
      if (wideFocalLength != null) {
        final zoomRatio = props.focalLength! / wideFocalLength;
        setZoomLevel(zoomRatio);
      }
    }
    
    if (kDebugMode) {
      print('✅ Switched to ${camera.name}');
    }
  } catch (e) {
    if (kDebugMode) {
      print('❌ Failed to switch camera: $e');
    }
    setErrorMessage('Failed to switch camera: $e');
  }
}

  // ============================================================================
  // PRIVATE HELPERS
  // ============================================================================

  Future<void> _applyFlashMode() async {
    if (_cameraController != null && _flashMode != null) {
      try {
        await _cameraController!.setFlashMode(_flashMode!);
      } catch (e) {
        if (kDebugMode) {
          print('${AppConstants.failedToSetFlashMode} $e');
        }
      }
    }
  }
  

  /// Dispose resources when done
  Future<void> dispose() async {
    await _cameraController?.dispose();
  }

  /// Convert digital zoom to effective focal length
/// 
/// Formula: Effective Focal Length = Base Focal Length × Digital Zoom
/// 
/// Example:
///   Wide camera: 4.25mm base, 1.5x digital zoom
///   Effective = 4.25mm × 1.5 = 6.375mm
double? digitalZoomToEffectiveFocalLength({
  required String cameraName,
  required double digitalZoom,
}) {
  final props = _cameraProperties[cameraName];
  if (props?.focalLength == null) return null;
  
  final baseFocalLength = props!.focalLength!;
  return baseFocalLength * digitalZoom;
}

/// Convert effective focal length to digital zoom for a camera
/// 
/// Formula: Digital Zoom = Effective Focal Length / Base Focal Length
/// 
/// Example:
///   Want 8.5mm effective focal length
///   Wide camera: 4.25mm base
///   Digital zoom = 8.5mm / 4.25mm = 2.0x
double? effectiveFocalLengthToDigitalZoom({
  required String cameraName,
  required double effectiveFocalLength,
}) {
  final props = _cameraProperties[cameraName];
  if (props?.focalLength == null || props!.focalLength! <= 0) return null;
  
  return effectiveFocalLength / props.focalLength!;
}

/// Convert total zoom (what user wants) to effective focal length
/// 
/// Formula: Effective Focal Length = Wide Camera Focal Length × Total Zoom
/// 
/// Example:
///   User wants 2.0x total zoom
///   Wide camera: 4.25mm
///   Effective = 4.25mm × 2.0 = 8.5mm
double? totalZoomToEffectiveFocalLength(double totalZoom) {
  // Find wide camera focal length
  double? wideFocalLength;
  
  for (final camera in _cameras) {
    if (camera.lensType == CameraLensType.wide && 
        camera.lensDirection == CameraLensDirection.back) {
      final props = _cameraProperties[camera.name];
      wideFocalLength = props?.focalLength;
      break;
    }
  }
  
  // Fallback: use shortest focal length
  if (wideFocalLength == null) {
    for (final props in _cameraProperties.values) {
      if (props.focalLength != null) {
        if (wideFocalLength == null || props.focalLength! < wideFocalLength!) {
          wideFocalLength = props.focalLength;
        }
      }
    }
  }
  
  if (wideFocalLength == null || wideFocalLength! <= 0) return null;
  
  return wideFocalLength * totalZoom;
}

/// Find the best camera for a target effective focal length
/// 
/// Returns the camera whose base focal length is closest to (but not over) the target
CameraDescription? _findBestCameraForEffectiveFocalLength(double targetEffectiveFocalLength) {
  if (_cameraProperties.isEmpty) return _currentCamera;
  
  // Get cameras in same direction as current camera
  final currentDirCameras = _cameras
      .where((c) => c.lensDirection == _currentCamera?.lensDirection)
      .toList();
  
  if (currentDirCameras.isEmpty) return _currentCamera;
  
  CameraDescription? bestCamera;
  double? smallestDifference;
  
  // Find camera with base focal length closest to target (but not over)
  for (final camera in currentDirCameras) {
    final props = _cameraProperties[camera.name];
    final baseFocalLength = props?.focalLength;
    
    if (baseFocalLength == null || baseFocalLength <= 0) continue;
    
    // If this camera's base focal length is <= target, it's a candidate
    if (baseFocalLength <= targetEffectiveFocalLength) {
      final difference = targetEffectiveFocalLength - baseFocalLength;
      
      // Pick camera with smallest difference (closest match)
      if (smallestDifference == null || difference < smallestDifference!) {
        smallestDifference = difference;
        bestCamera = camera;
      }
    }
  }
  
  // If no camera found (target below all base focal lengths), use first camera
  return bestCamera ?? currentDirCameras.first;
}

/// Calculate digital zoom needed for a camera to reach target effective focal length
double? calculateDigitalZoomForTargetFocalLength({
  required String cameraName,
  required double targetEffectiveFocalLength,
}) {
  return effectiveFocalLengthToDigitalZoom(
    cameraName: cameraName,
    effectiveFocalLength: targetEffectiveFocalLength,
  );
}
}
