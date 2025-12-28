import 'package:flutter/services.dart';
import 'camera_info_platform_interface.dart';

/// Default implementation using method channels
class MethodChannelCameraInfo extends CameraInfoPlatform {
  static const MethodChannel _channel = MethodChannel('camera_info');
  
  @override
  Future<Map<String, dynamic>> getCameraProperties(String cameraId) async {
    final result = await _channel.invokeMethod<Map>('getCameraProperties', {
      'cameraId': cameraId,
    });
    
    if (result == null) {
      throw PlatformException(
        code: 'NO_DATA',
        message: 'No camera properties returned for $cameraId',
      );
    }
    
    return Map<String, dynamic>.from(result);
  }
  
  @override
  Future<Map<String, Map<String, dynamic>>> getAllCameraProperties() async {
    final result = await _channel.invokeMethod<Map>('getAllCameraProperties');
    
    if (result == null) {
      throw PlatformException(
        code: 'NO_DATA',
        message: 'No camera properties returned',
      );
    }
    
    return Map<String, Map<String, dynamic>>.from(
      result.map((key, value) => MapEntry(
        key.toString(),
        Map<String, dynamic>.from(value as Map),
      )),
    );
  }
}