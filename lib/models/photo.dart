class Photo {
  final String id;
  final String path;
  final DateTime dateTaken;
  final String? albumId;
  final double? latitude;
  final double? longitude;
  final Map<String, dynamic>? metadata;
  final List<String> tags;
  bool isFavorite;

  Photo({
    required this.id,
    required this.path,
    required this.dateTaken,
    this.albumId,
    this.latitude,
    this.longitude,
    this.metadata,
    this.tags = const [],
    this.isFavorite = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'path': path,
      'dateTaken': dateTaken.toIso8601String(),
      'albumId': albumId,
      'latitude': latitude,
      'longitude': longitude,
      'metadata': metadata,
      'tags': tags,
      'isFavorite': isFavorite,
    };
  }

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      path: json['path'],
      dateTaken: DateTime.parse(json['dateTaken']),
      albumId: json['albumId'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      metadata: json['metadata'],
      tags: List<String>.from(json['tags'] ?? []),
      isFavorite: json['isFavorite'] ?? false,
    );
  }
}
