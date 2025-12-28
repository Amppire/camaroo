import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'method_channel_camera_info.dart';

/// Platform interface for camera_info plugin
abstract class CameraInfoPlatform extends PlatformInterface {
  CameraInfoPlatform() : super(token: _token);
  
  static final Object _token = Object();
  static CameraInfoPlatform _instance = MethodChannelCameraInfo();
  
  static CameraInfoPlatform get instance => _instance;
  
  static set instance(CameraInfoPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
  
  /// Get camera properties for a specific camera
  Future<Map<String, dynamic>> getCameraProperties(String cameraId) {
    throw UnimplementedError('getCameraProperties() has not been implemented.');
  }
  
  /// Get camera properties for all cameras
  Future<Map<String, Map<String, dynamic>>> getAllCameraProperties() {
    throw UnimplementedError('getAllCameraProperties() has not been implemented.');
  }
}