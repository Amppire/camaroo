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
    // CameraController? get cameraController;

  // Cameras
  // TODO: Doc.
  List<CameraDescription> get cameras;
  Function(List<CameraDescription>) onCamerasChanged = (cameras) {};
  void setCameras(List<CameraDescription> newCameras);

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

  // Picture Taken
  // TODO: Doc.
  XFile? get pictureTaken;
  Function(XFile?) onPictureTakenChanged = (pictureTaken) {};
  void setPictureTaken(XFile? newPictureTaken);

  /// Functions
  /// ---------------------------------------------------------------------------
  
  /// Initialzes phone's camera. 
  /// Will return error if no cameras are found or if the camera is not available.
  /// 
  void initializeCamera();

  /// Switches to the next camera.
  /// Will return error if there is only one camera or if the camera is not available.
  /// 
  void switchCamera();

  /// Takes a picture.
  /// Will return error if the camera is not ready.
  /// 
  void takePicture();

  /// Toggles the flash mode.
  /// Will return error if the flash mode is not available.
  /// 
  void toggleFlash();

}