import 'tag.dart';

class Category extends Tag {
  @override
  final int icon;
  final String? parentId;

  Category({
    required super.id,
    required super.name,
    super.description,
    super.color,
    super.isActive = true,
    super.createdAt,
    super.updatedAt,
    required this.icon,
    this.parentId,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    int parseIconSafely(dynamic value) {
      if (value == null) return 0xe5d8;
      if (value is int) return value;
      if (value is String) {
        try {
          return int.parse(value);
        } catch (e) {
          return 0xe5d8; // Default to label icon if parsing fails
        }
      }
      return 0xe5d8;
    }

    int parseColorSafely(dynamic value) {
      if (value == null) return 0xFF9E9E9E;
      if (value is int) return value;
      if (value is String) {
        try {
          if (value.startsWith('#')) {
            return int.parse('0xFF${value.substring(1)}');
          }
          return int.parse(value);
        } catch (e) {
          return 0xFF9E9E9E; // Default to grey if parsing fails
        }
      }
      return 0xFF9E9E9E;
    }

    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      icon: parseIconSafely(json['icon']),
      color: parseColorSafely(json['color']),
      parentId: json['parent_id'],
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'icon': icon,
      'parent_id': parentId,
    });
    return json;
  }

  @override
  Category copyWith({
    String? id,
    String? name,
    String? description,
    int? icon,
    int? color,
    String? parentId,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      parentId: parentId ?? this.parentId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}