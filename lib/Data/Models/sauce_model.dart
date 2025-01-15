class SauceModel {
  final int id;
  final String name;
  final String? hexColor;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SauceModel({
    required this.id,
    required this.name,
    this.hexColor,
    this.createdAt,
    this.updatedAt,
  });

  factory SauceModel.fromJson(Map<String, dynamic> json) {
    return SauceModel(
      id: json['id'],
      name: json['name'],
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
      'hex_color': hexColor,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
