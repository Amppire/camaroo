/// Represents a storage item with metadata
class StorageItem<T> {
  final String key;
  final T value;
  final DateTime createdAt;
  final DateTime? updatedAt;

  StorageItem({required this.key, required this.value, required this.createdAt, this.updatedAt});

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  factory StorageItem.fromJson(Map<String, dynamic> json) {
    return StorageItem(
      key: json['key'] as String,
      value: json['value'] as T,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
    );
  }
}
