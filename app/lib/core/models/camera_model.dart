import 'package:camaroo/core/models/photo_storage_service.dart';
import 'package:camaroo/data_models/photo.dart';
import 'package:camera/camera.dart';
import 'package:camaroo/core/abstractions/camera_api.dart';
import 'package:camaroo/core/abstractions/photo_storage_service_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:storage/storage.dart';

class CameraApiModel implements CameraApi {
  CameraApiModel({required StorageService storageService}) : _storageService = storageService;
  final StorageService _storageService;
  late final PhotoStorageServiceApi _photoStorageService = PhotoStorageService(
    storageService: _storageService,
  );

  CameraStatus _cameraStatus = CameraStatus.uninitialized;
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  String? _errorMessage;
  int _currentCameraIndex = 0;
  FlashMode? _flashMode = FlashMode.off;
  XFile? _pictureTaken;

  // Camera Status
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

  // Camera Index
  @override
  int get currentCameraIndex => _currentCameraIndex;

  @override
  Function(int) onCurrentCameraIndexChanged = (currentCameraIndex) {};

  @override
  void setCurrentCameraIndex(int newCameraIndex) {
    _currentCameraIndex = newCameraIndex;
    onCurrentCameraIndexChanged(newCameraIndex);
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
        onCamerasChanged(_cameras);
      }

      // Business rule: Must have at least one camera
      if (_cameras.isEmpty) {
        setErrorMessage('No cameras found on this device');
        setStatus(CameraStatus.error);
        return;
      }

      // Dispose old controller if exists
      await _cameraController?.dispose();

      // Create new controller with current camera
      final camera = _cameras[_currentCameraIndex];
      final controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      // Initialize the controller
      await controller.initialize();

      // Lock capture orientation to portrait
      // Avoids weird behavior where the camera sensor rotates with the device.
      await controller.lockCaptureOrientation(DeviceOrientation.portraitUp);

      // Set flash mode
      await controller.setFlashMode(_flashMode ?? FlashMode.off);

      // Update state
      setCameraController(controller);
      setStatus(CameraStatus.ready);
    } on CameraException catch (e) {
      setErrorMessage('Camera error: ${e.description}');
      setStatus(CameraStatus.error);
    } catch (e) {
      setErrorMessage('Unexpected error: $e');
      setStatus(CameraStatus.error);
    }
  }

  @override
  Future<void> switchCamera() async {
    // Business rule: Can't switch if only one camera
    if (cameras.length <= 1) {
      setErrorMessage('Only one camera available');
      return;
    }

    // Business rule: Can't switch while taking picture
    if (status == CameraStatus.takingPicture) {
      setErrorMessage('Cannot switch while taking picture');
      return;
    }

    // Calculate next camera index (business logic)
    final newIndex = (_currentCameraIndex + 1) % cameras.length;
    setCurrentCameraIndex(newIndex);

    // Re-initialize with new camera
    await initializeCamera();
  }

  @override
  Future<void> takePicture() async {
    // Business rules: Camera must be ready
    if (status != CameraStatus.ready) {
      setErrorMessage('Camera not ready');
      return;
    }

    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      setErrorMessage('Camera controller not initialized');
      return;
    }

    setStatus(CameraStatus.takingPicture);
    setErrorMessage(null);

    try {
      final XFile picture = await _cameraController!.takePicture();
      setPictureTaken(picture);

      final photo = Photo(id: picture.path, filePath: picture.path, capturedAt: DateTime.now());
      await _photoStorageService.savePhoto(photo);

      setStatus(CameraStatus.ready);
    } on CameraException catch (e) {
      setErrorMessage('Failed to take picture: ${e.description}');
      setStatus(CameraStatus.ready);
    } catch (e) {
      setErrorMessage('Unexpected error: $e');
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

  // ============================================================================
  // PRIVATE HELPERS
  // ============================================================================

  Future<void> _applyFlashMode() async {
    if (_cameraController != null && _flashMode != null) {
      try {
        await _cameraController!.setFlashMode(_flashMode!);
      } catch (e) {
        if (kDebugMode) {
          print('Failed to set flash mode: $e');
        }
      }
    }
  }

  /// Dispose resources when done
  Future<void> dispose() async {
    await _cameraController?.dispose();
  }
}
