class Photo {
  final String id;
  final String filePath;
  final DateTime capturedAt;
  final String? cameraType; // front or back
  final bool hasFlash;

  Photo({
    required this.id,
    required this.filePath,
    required this.capturedAt,
    this.cameraType,
    this.hasFlash = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filePath': filePath,
      'capturedAt': capturedAt.toIso8601String(),
      'cameraType': cameraType,
      'hasFlash': hasFlash,
    };
  }

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] as String,
      filePath: json['filePath'] as String,
      capturedAt: DateTime.parse(json['capturedAt'] as String),
      cameraType: json['cameraType'] as String?,
      hasFlash: json['hasFlash'] as bool? ?? false,
    );
  }

  @override
  String toString() => 'Photo(id: $id, path: $filePath, at: $capturedAt)';
}
