import 'package:camera/camera.dart';
import 'package:camaroo/core/abstractions/camera_api.dart';

class CameraApiModel implements CameraApi {
  CameraStatus _cameraStatus = CameraStatus.initializing;
  // CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  String? _errorMessage;
  int _currentCameraIndex = 0;
  FlashMode? _flashMode;
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
  // @override
  // CameraController? get cameraController => _cameraController;

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

  @override
  void initializeCamera() {
    // Validation
    if (status == CameraStatus.initializing) {
      return; // Already initializing
    }

    // Update state
    setStatus(CameraStatus.initializing);
    setErrorMessage(null);

    // Tell UI to perform the actual initialization
   setStatus(CameraStatus.initializing);
  }

   @override
  void switchCamera() {
    // Business rule: Can't switch if only one camera
    if (cameras.length <= 1) {
      setErrorMessage('Only one camera available');
      return;
    }

    // Business rule: Can't switch while taking picture
    if (status == CameraStatus.takingPicture) {
      return;
    }

    // Calculate next camera index (business logic)
    final newIndex = (_currentCameraIndex + 1) % cameras.length;

    // Update state
    setStatus(CameraStatus.initializing);
    setErrorMessage(null);
    setCurrentCameraIndex(newIndex);

    // Tell UI to perform the actual switch
    setCurrentCameraIndex(newIndex);
  }


  @override
  void takePicture() {
    // Business rules
    if (status != CameraStatus.ready) {
      setErrorMessage('Camera not ready');
      return;
    }

    setStatus(CameraStatus.takingPicture);
    // UI will handle the actual picture taking
  }

    @override
  void toggleFlash() {
    // Pure business logic - no platform code
    FlashMode newMode;
    switch (flashMode) {
      case FlashMode.off:
        newMode = FlashMode.auto;
        break;
      case FlashMode.auto:
        newMode = FlashMode.always;
        break;
      case FlashMode.always:
        newMode = FlashMode.off;
        break;
      case null:
        newMode = FlashMode.auto;
        break;
      case FlashMode.torch:
        newMode = FlashMode.off;
        break;
    }
    setFlashMode(newMode);
  }

    

}
