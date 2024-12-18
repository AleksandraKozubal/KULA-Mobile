class FillingModel {
  final int id;
  final String name;
  final bool isVegan;
  final String? hexColor;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FillingModel({
    required this.id,
    required this.name,
    required this.isVegan,
    this.hexColor,
    this.createdAt,
    this.updatedAt,
  });

  factory FillingModel.fromJson(Map<String, dynamic> json) {
    return FillingModel(
      id: json['id'],
      name: json['name'],
      isVegan: json['is_vegan'] == '1',
      hexColor: json['hex_color'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_vegan': isVegan ? '1' : '0',
      'hex_color': hexColor,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}