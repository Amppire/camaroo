import 'package:camaroo/utils/app_constants.dart';
import 'package:camaroo/core/abstractions/camera_api.dart';
import 'package:native_camera_kit/native_camera_kit.dart';
import 'package:storage/storage.dart';

class CameraApiModel implements CameraApi {
  CameraApiModel({required StorageService storageService}) : _storageService = storageService;

  final StorageService _storageService;


  CameraStatus _cameraStatus = CameraStatus.uninitialized;
  NativeCameraController? _cameraController;
  String? _errorMessage;
  FlashMode? _flashMode = FlashMode.off;

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


  // Camera Controller
  @override
  NativeCameraController? get cameraNativeController => _cameraController;

  @override
  Function(NativeCameraController?) onCameraNativeControllerChanged = (cameraNativeController) {};

  @override
  void setCameraNativeController(NativeCameraController? newCameraNativeController) {
    _cameraController = newCameraNativeController;
    onCameraNativeControllerChanged(newCameraNativeController);
  }


  // Flash Mode
  @override
  FlashMode get flashMode => _flashMode ?? FlashMode.off;

  @override
  Function(FlashMode?) onFlashModeChanged = (flash) {};

  @override
  void setFlashMode(FlashMode? newFlashMode) {
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
    try {
      await _cameraController?.initializeDefault();
    } catch (e) {
      print('Error initializing camera: $e');
      setErrorMessage('${AppConstants.unexpectedError} $e');
      setStatus(CameraStatus.error);
    }
  }

  @override
  Future<void> switchCamera() async {
    // TODO: Implement
  }

  @override
  Future<void> toggleFlash() async {
    // Pure business logic - cycle through flash modes
    FlashMode newMode;
    switch (_flashMode ?? FlashMode.off) {
      case FlashMode.off:
        newMode = FlashMode.auto;
        break;
      case FlashMode.auto:
        newMode = FlashMode.on;
        break;
      case FlashMode.on:
        newMode = FlashMode.auto;
        break;
      case FlashMode.torch:
        newMode = FlashMode.off;
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
