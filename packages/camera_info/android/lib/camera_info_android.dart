import 'package:camera_info_platform_interface/camera_info_platform_interface.dart';
import 'package:flutter/foundation.dart';

/// Android implementation of the CameraInfoPlatform
class CameraInfoAndroid extends CameraInfoPlatform {
  /// Registers this class as the default instance of [CameraInfoPlatform]
  static void registerWith() {
    CameraInfoPlatform.instance = CameraInfoAndroid();
  }

  @override
  Future<Map<String, dynamic>> getCameraProperties(String cameraId) async {
    // This will be handled by the native Android code via MethodChannel
    // The MethodChannelCameraInfo already handles this
    return super.getCameraProperties(cameraId);
  }

  @override
  Future<Map<String, Map<String, dynamic>>> getAllCameraProperties() async {
    // This will be handled by the native Android code via MethodChannel
    // The MethodChannelCameraInfo already handles this
    return super.getAllCameraProperties();
  }
}
