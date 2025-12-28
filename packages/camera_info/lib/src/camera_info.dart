import 'package:camera_info_platform_interface/camera_info_platform_interface.dart';
import 'models/camera_properties.dart';
import 'models/camera_exceptions.dart';

/// Main API for retrieving camera hardware information
class CameraInfo {
  CameraInfo._();
  
  static final CameraInfo instance = CameraInfo._();
  
  /// Platform implementation
  static CameraInfoPlatform get _platform => CameraInfoPlatform.instance;
  
  /// Get hardware properties for a specific camera
  /// 
  /// [cameraId] should match the CameraDescription.name from the camera package
  /// 
  /// Returns [CameraProperties] with focal length, field of view, and base zoom
  /// 
  /// Throws [CameraInfoException] if the camera is not found or info cannot be retrieved
  Future<CameraProperties> getCameraProperties(String cameraId) async {
    try {
      final result = await _platform.getCameraProperties(cameraId);
      
      return CameraProperties(
        cameraId: result['cameraId'] as String,
        focalLength: result['focalLength'] as double?,
        fieldOfView: result['fieldOfView'] as double?,
        baseZoom: result['baseZoom'] as double?,
        sensorSize: result['sensorSize'] != null
            ? Size(
                (result['sensorSize'] as Map)['width'] as double,
                (result['sensorSize'] as Map)['height'] as double,
              )
            : null,
      );
    } catch (e) {
      if (e is CameraInfoException) rethrow;
      throw CameraInfoException(
        code: 'UNKNOWN_ERROR',
        message: 'Failed to get camera properties: $e',
        details: e,
      );
    }
  }
  
  /// Get hardware properties for all available cameras
  /// 
  /// Returns a map of cameraId -> CameraProperties
  Future<Map<String, CameraProperties>> getAllCameraProperties() async {
    try {
      final result = await _platform.getAllCameraProperties();
      
      return Map<String, CameraProperties>.fromEntries(
        result.entries.map((entry) {
          final data = entry.value as Map;
          return MapEntry(
            entry.key,
            CameraProperties(
              cameraId: data['cameraId'] as String,
              focalLength: data['focalLength'] as double?,
              fieldOfView: data['fieldOfView'] as double?,
              baseZoom: data['baseZoom'] as double?,
              sensorSize: data['sensorSize'] != null
                  ? Size(
                      (data['sensorSize'] as Map)['width'] as double,
                      (data['sensorSize'] as Map)['height'] as double,
                    )
                  : null,
            ),
          );
        }),
      );
    } catch (e) {
      if (e is CameraInfoException) rethrow;
      throw CameraInfoException(
        code: 'UNKNOWN_ERROR',
        message: 'Failed to get all camera properties: $e',
        details: e,
      );
    }
  }
  
  /// Calculate base zoom for a camera relative to the wide camera
  /// 
  /// This is a convenience method that calculates baseZoom from fieldOfView
  /// if baseZoom is not directly available from the platform
  double? calculateBaseZoom({
    required double? fieldOfView,
    double? wideCameraFieldOfView,
  }) {
    if (fieldOfView == null) return null;
    if (wideCameraFieldOfView == null) return null;
    
    // Base zoom is inversely proportional to field of view
    // Wider FOV = lower base zoom
    return wideCameraFieldOfView / fieldOfView;
  }
}