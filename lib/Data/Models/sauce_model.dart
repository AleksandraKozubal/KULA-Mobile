class SauceModel {
  final int id;
  final String name;
  final String spiciness;
  final bool isVegan;
  final bool isGlutenFree;
  final String? hexColor;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SauceModel({
    required this.id,
    required this.name,
    required this.spiciness,
    required this.isVegan,
    required this.isGlutenFree,
    this.hexColor,
    this.createdAt,
    this.updatedAt,
  });

  factory SauceModel.fromJson(Map<String, dynamic> json) {
    return SauceModel(
      id: json['id'],
      name: json['name'],
      spiciness: json['spiciness'],
      isVegan: json['is_vegan'] == '1',
      isGlutenFree: json['is_gluten_free'] == '1',
      hexColor: json['hex_color'],
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
      'spiciness': spiciness,
      'is_vegan': isVegan ? '1' : '0',
      'is_gluten_free': isGlutenFree ? '1' : '0',
      'hex_color': hexColor,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
