import 'package:camaroo/core/abstractions/camera_api.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraAdapter {
  CameraAdapter(CameraApi cameraApi) {
    statusNotifier = ValueNotifier(cameraApi.status);
    cameraApi.onStatusChanged = (status) => statusNotifier.value = status;

    camerasNotifier = ValueNotifier(cameraApi.cameras);
    cameraApi.onCamerasChanged = (cameras) => camerasNotifier.value = cameras;

    currentCameraIndexNotifier = ValueNotifier(cameraApi.currentCameraIndex);
    cameraApi.onCurrentCameraIndexChanged = (currentCameraIndex) => currentCameraIndexNotifier.value = currentCameraIndex;

    flashModeNotifier = ValueNotifier(cameraApi.flashMode);
    cameraApi.onFlashModeChanged = (flashMode) => flashModeNotifier.value = flashMode;

    errorMessageNotifier = ValueNotifier(cameraApi.errorMessage);
    cameraApi.onErrorMessageChanged = (errorMessage) => errorMessageNotifier.value = errorMessage;

    pictureTakenNotifier = ValueNotifier(cameraApi.pictureTaken);
    cameraApi.onPictureTakenChanged = (pictureTaken) => pictureTakenNotifier.value = pictureTaken;

  }

  late final ValueNotifier<CameraStatus> statusNotifier;
  late final ValueNotifier<List<CameraDescription>> camerasNotifier;
  late final ValueNotifier<int> currentCameraIndexNotifier;
  late final ValueNotifier<FlashMode?> flashModeNotifier;
  late final ValueNotifier<String?> errorMessageNotifier;
  late final ValueNotifier<XFile?> pictureTakenNotifier;
}