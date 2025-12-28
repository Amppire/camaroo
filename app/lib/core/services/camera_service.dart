import 'package:camaroo/utils/app_constants.dart';
import 'package:native_camera_kit/native_camera_kit.dart' as native_camera_kit;
import 'package:camaroo/core/abstractions/camera_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:storage/storage.dart';

class CameraApiModel implements CameraApi {
  CameraApiModel({required StorageService storageService}) : _storageService = storageService;

  final StorageService _storageService;


  native_camera_kit.CameraStatus _cameraStatus = native_camera_kit.CameraStatus.uninitialized;
  native_camera_kit.NativeCameraController? _cameraController;
  String? _errorMessage;
  native_camera_kit.FlashMode? _flashMode = native_camera_kit.FlashMode.off;

  // Camera Status
  @override
  native_camera_kit.CameraStatus get status => _cameraStatus;

  @override
  Function(native_camera_kit.CameraStatus) onStatusChanged = (status) {};

  @override
  void setStatus(native_camera_kit.CameraStatus newStatus) {
    _cameraStatus = newStatus;
    onStatusChanged(newStatus);
  }


  // Camera Controller
  @override
  native_camera_kit.NativeCameraController? get cameraNativeController => _cameraController;

  @override
  Function(native_camera_kit.NativeCameraController?) onCameraNativeControllerChanged = (cameraNativeController) {};

  @override
  void setCameraNativeController(native_camera_kit.NativeCameraController? newCameraNativeController) {
    _cameraController = newCameraNativeController;
    onCameraNativeControllerChanged(newCameraNativeController);
  }


  // Flash Mode
  @override
  native_camera_kit.FlashMode get flashMode => _flashMode ?? native_camera_kit.FlashMode.off;

  @override
  Function(native_camera_kit.FlashMode?) onFlashModeChanged = (flash) {};

  @override
  void setFlashMode(native_camera_kit.FlashMode? newFlashMode) {
    _flashMode = newFlashMode;
    onFlashModeChanged(newFlashMode);
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

  // ============================================================================
  // PUBLIC METHODS
  // ============================================================================

  @override
  Future<void> initializeCamera() async {
    // Validation: Don't re-initialize if already initializing
    if (status == native_camera_kit.CameraStatus.initializing) {
      return;
    }

    // Update state
    setStatus(native_camera_kit.CameraStatus.initializing);
    setErrorMessage(null);

    try {

      // Dispose old controller if exists
      await _cameraController?.dispose();


      // Initialize the controller
      await _cameraController?.initializeDefault();

      // Set flash mode
      await _cameraController?.setFlashMode(_flashMode ?? native_camera_kit.FlashMode.off);

      // Update state
      setCameraNativeController(_cameraController);
      setStatus(native_camera_kit.CameraStatus.ready);
    } on Error catch (e) {
      setErrorMessage('${AppConstants.cameraNotReady} ${e.toString()}');
      setStatus(native_camera_kit.CameraStatus.error);
    } catch (e) {
      setErrorMessage('${AppConstants.unexpectedError} $e');
      setStatus(native_camera_kit.CameraStatus.error);
    }
  }

  @override
  Future<void> switchCamera() async {
    // TODO: Implement
  }

  @override
  Future<void> toggleFlash() async {
    // Pure business logic - cycle through flash modes
    native_camera_kit.FlashMode newMode;
    switch (_flashMode ?? native_camera_kit.FlashMode.off) {
      case native_camera_kit.FlashMode.off:
        newMode = native_camera_kit.FlashMode.auto;
        break;
      case native_camera_kit.FlashMode.auto:
        newMode = native_camera_kit.FlashMode.on;
        break;
      case native_camera_kit.FlashMode.on:
        newMode = native_camera_kit.FlashMode.auto;
        break;
      case native_camera_kit.FlashMode.torch:
        newMode = native_camera_kit.FlashMode.off;
        break;
    }

    setFlashMode(newMode);
  }
  
  @override
  void takePicture() {
    // TODO: implement takePicture
  }

  // ============================================================================
  // PRIVATE HELPERS
  // ============================================================================

}
