import 'package:camera/camera.dart';

enum CameraStatus {uninitialized, initializing, ready, error, takingPicture}

abstract class CameraApi {
  // Camera Status
  // TODO: Doc.
  CameraStatus get status;
  Function(CameraStatus) onStatusChanged = (status) {};
  void setStatus(CameraStatus newStatus);

  // Camera Controller
  // TODO: Doc.
  CameraController? get cameraController;

  // Camera Index
  // TODO: Doc.
  int get currentCameraIndex;
  Function(int) onCurrentCameraIndexChanged = (currentCameraIndex) {};
  void setCurrentCameraIndex(int newCameraIndex);

  // Flash Mode
  // TODO: Doc.
  FlashMode? get flashMode;
  Function(FlashMode?) onFlashModeChanged = (flashMode) {};
  void setFlashMode(FlashMode? newFlashMode);

  // Error Message
  // TODO: Doc.
  String? get errorMessage;
  Function(String?) onErrorMessageChanged = (errorMessage) {};
  void setErrorMessage(String? newErrorMessage);

  /// Functions
  /// ---------------------------------------------------------------------------
  
  /// Initialzes phone's camera. 
  /// Will return error if no cameras are found or if the camera is not available.
  /// 
  Future<void> initializeCamera();

  
}