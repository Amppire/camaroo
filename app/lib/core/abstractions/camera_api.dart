import 'dart:typed_data';

import 'package:native_camera_kit/native_camera_kit.dart';
abstract class CameraApi {

  // Camera Controller
  NativeCameraController? get cameraNativeController;


  // Camera Status
  // TODO: Doc.
  CameraStatus get status;
  Function(CameraStatus) onStatusChanged = (status) {};
  void setStatus(CameraStatus newStatus);



  // Flash Mode
  // TODO: Doc.
  FlashMode get flashMode;
  Function(FlashMode) onFlashModeChanged = (flashMode) {};
  void setFlashMode(FlashMode newFlashMode);

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
