/// Camera hardware properties retrieved from native platform
class CameraProperties {
  /// Camera identifier (matches CameraDescription.name)
  final String cameraId;
  
  /// Focal length in millimeters
  final double? focalLength;
  
  /// Field of view in degrees (horizontal)
  final double? fieldOfView;
  
  /// Calculated base optical zoom (relative to wide camera = 1.0x)
  final double? baseZoom;
  
  /// Sensor size in pixels (width x height)
  final Size? sensorSize;
  
  const CameraProperties({
    required this.cameraId,
    this.focalLength,
    this.fieldOfView,
    this.baseZoom,
    this.sensorSize,
  });
  
  @override
  String toString() {
    return 'CameraProperties(cameraId: $cameraId, '
           'focalLength: $focalLength mm, '
           'fieldOfView: $fieldOfView°, '
           'baseZoom: ${baseZoom}x)';
  }
}

/// Size helper class
class Size {
  final double width;
  final double height;
  
  const Size(this.width, this.height);
  
  @override
  String toString() => 'Size($width x $height)';
}

