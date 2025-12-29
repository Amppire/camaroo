import 'dart:typed_data';

import 'package:native_camera_kit/native_camera_kit.dart' as native_camera_kit;
abstract class CameraApi {
  // Camera Status
  // TODO: Doc.
  native_camera_kit.CameraStatus get status;
  Function(native_camera_kit.CameraStatus) onStatusChanged = (status) {};
  void setStatus(native_camera_kit.CameraStatus newStatus);

  // Camera Controller
  native_camera_kit.NativeCameraController? get cameraNativeController;
  Function(native_camera_kit.NativeCameraController?) onCameraNativeControllerChanged = (cameraNativeController) {};
  void setCameraNativeController(native_camera_kit.NativeCameraController? newCameraNativeController);

  // Flash Mode
  // TODO: Doc.
  native_camera_kit.FlashMode get flashMode;
  Function(native_camera_kit.FlashMode?) onFlashModeChanged = (flashMode) {};
  void setFlashMode(native_camera_kit.FlashMode? newFlashMode);

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
  void initializeCamera();

  /// Switches to the next camera.
  /// Will return error if there is only one camera or if the camera is not available.
  ///
  void switchCamera();

  /// Takes a picture.
  /// Will return error if the camera is not ready.
  ///
  Future<Uint8List> takePicture();

  /// Toggles the flash mode.
  /// Will return error if the flash mode is not available.
  ///
  void toggleFlash();
}
