import 'package:camera/camera.dart';

enum CameraStatus { uninitialized, initializing, ready, error, takingPicture }

abstract class CameraApi {
  // Camera Status
  // TODO: Doc.
  CameraStatus get status;
  Function(CameraStatus) onStatusChanged = (status) {};
  void setStatus(CameraStatus newStatus);

  // Camera Controller
  CameraController? get cameraController;
  Function(CameraController?) onCameraControllerChanged = (cameraController) {};
  void setCameraController(CameraController? newCameraController);

  // Cameras
  // TODO: Doc.
  List<CameraDescription> get cameras;
  Function(List<CameraDescription>) onCamerasChanged = (cameras) {};
  void setCameras(List<CameraDescription> newCameras);

  // Current Camera
  CameraDescription? get currentCamera;
  Function(CameraDescription?) onCurrentCameraChanged = (currentCamera) {};
  void setCurrentCamera(CameraDescription? newCurrentCamera);

  // Flash Mode
  // TODO: Doc.
  FlashMode? get flashMode;
  Function(FlashMode?) onFlashModeChanged = (flashMode) {};
  void setFlashMode(FlashMode? newFlashMode);

  // Zoom Level (deprecated - use focalLength instead)
  double? get zoomLevel;
  Function(double?) onZoomLevelChanged = (zoomLevel) {};
  void setZoomLevel(double? newZoomLevel);

  // Focal Length (in mm) - iOS-style
  double? get focalLength;
  Function(double?) onFocalLengthChanged = (focalLength) {};
  void _setFocalLengthState(double? newFocalLength); // Internal state setter

  // Min/Max Focal Lengths (in mm)
  double? get minFocalLength;
  double? get maxFocalLength;
  Function(double, double) onFocalLengthRangeChanged = (min, max) {};
  void setFocalLengthRange(double min, double max);

  // Focal Length Stops (camera switch points in mm)
  List<double> get focalLengthStops;
  Function(List<double>) onFocalLengthStopsChanged = (stops) {};
  void setFocalLengthStops(List<double> stops);

  // Min/Max Zoom Levels (deprecated - kept for compatibility)
  double? get minZoomLevel;
  double? get maxZoomLevel;
  Function(double, double) onZoomRangeChanged = (min, max) {};
  void setZoomRange(double min, double max);

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

  /// Sets the zoom level (deprecated - use setFocalLength instead).
  /// Will return error if the zoom level is not available.
  ///
  void setZoom(double zoom);

  /// Sets the focal length in millimeters (iOS-style).
  /// Automatically switches cameras and applies digital zoom as needed.
  ///
  Future<void> setFocalLength(double focalLengthMm);
}
