class Album {
  final String id;
  final String name;
  final DateTime createdAt;
  final String? coverPhotoPath;
  int photoCount;
  
  Album({
    required this.id,
    required this.name,
    required this.createdAt,
    this.coverPhotoPath,
    this.photoCount = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'coverPhotoPath': coverPhotoPath,
      'photoCount': photoCount,
    };
  }

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['createdAt']),
      coverPhotoPath: json['coverPhotoPath'],
      photoCount: json['photoCount'] ?? 0,
    );
  }
}
