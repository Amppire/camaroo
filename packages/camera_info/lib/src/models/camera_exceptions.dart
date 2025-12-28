/// Exception thrown when camera info operations fail
class CameraInfoException implements Exception {
  final String code;
  final String message;
  final dynamic details;
  
  const CameraInfoException({
    required this.code,
    required this.message,
    this.details,
  });
  
  @override
  String toString() => 'CameraInfoException($code): $message';
}

