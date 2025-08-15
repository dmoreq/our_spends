class Tag {
  final String id;
  final String name;
  final String? description;
  final int color;
  final int iconCodePoint;
  final String iconFontFamily;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Tag({
    required this.id,
    required this.name,
    this.description,
    this.color = 0xFF9E9E9E,
    this.iconCodePoint = 0xe5d8,
    this.iconFontFamily = 'MaterialIcons',
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      color: json['color'] is String ? int.parse(json['color']) : (json['color'] ?? 0xFF9E9E9E),
      iconCodePoint: json['icon'] is String ? int.parse(json['icon']) : (json['icon'] ?? 0xe5d8),
      iconFontFamily: json['icon_font_family'] ?? 'MaterialIcons',
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'color': color,
      'icon': iconCodePoint,
      'icon_font_family': iconFontFamily,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Tag copyWith({
    String? id,
    String? name,
    String? description,
    int? color,
    int? iconCodePoint,
    String? iconFontFamily,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Tag(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      iconFontFamily: iconFontFamily ?? this.iconFontFamily,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}