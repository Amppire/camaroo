import 'package:camera/camera.dart';
import 'package:camaroo/core/abstractions/camera_api.dart';

class CameraApiModel implements CameraApi {
  CameraStatus _cameraStatus = CameraStatus.initializing;
  CameraController? _cameraController;
  List<CameraDescription> cameras = [];
  String? _errorMessage;
  int _currentCameraIndex = 0;
  FlashMode? _flashMode;

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
  CameraController? get cameraController => _cameraController;

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
  Future<void> initializeCamera() async {
    try {
      setStatus(CameraStatus.initializing);
      setErrorMessage(null);

      // Get the available cameras
      cameras = await availableCameras();

      if (cameras.isEmpty) {
        setErrorMessage('No cameras found');
        setStatus(CameraStatus.error);
        return;
      }

      // Initialize the camera controller with the first camera
      _cameraController = CameraController(
        cameras[currentCameraIndex],
        ResolutionPreset.high,
      );

      final cameraController = _cameraController;
      if (cameraController != null) {
        await cameraController.initialize();
      }
    } catch (e) {
      _errorMessage = e.toString();
    }
  }
}
