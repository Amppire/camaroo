import 'package:camaroo/core/abstractions/camera_api.dart';
  import 'package:native_camera_kit/native_camera_kit.dart' as native_camera_kit;
import 'package:flutter/material.dart';

class CameraAdapter {
  CameraAdapter(CameraApi cameraApi) {
    statusNotifier = ValueNotifier(cameraApi.status);
    cameraApi.onStatusChanged = (status) => statusNotifier.value = status;


    flashModeNotifier = ValueNotifier(cameraApi.flashMode);
    cameraApi.onFlashModeChanged = (flashMode) =>
        flashModeNotifier.value = flashMode;

    errorMessageNotifier = ValueNotifier(cameraApi.errorMessage);
    cameraApi.onErrorMessageChanged = (errorMessage) =>
        errorMessageNotifier.value = errorMessage;

  }

  late final ValueNotifier<native_camera_kit.CameraStatus> statusNotifier;
  late final ValueNotifier<native_camera_kit.FlashMode?> flashModeNotifier;
  late final ValueNotifier<String?> errorMessageNotifier;
}
