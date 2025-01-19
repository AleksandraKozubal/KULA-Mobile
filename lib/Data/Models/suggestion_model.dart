class SuggestionModel {
  final int id;
  final String name;
  final String description;
  final String status;
  final int userId;
  final int kebabPlaceId;
  final String? comment;
  final DateTime createdAt;
  final DateTime updatedAt;

  SuggestionModel({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.userId,
    required this.kebabPlaceId,
    required this.createdAt,
    required this.updatedAt,
    this.comment,
  });

  factory SuggestionModel.fromJson(Map<String, dynamic> json) {
    return SuggestionModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      status: json['status'],
      userId: json['user_id'],
      kebabPlaceId: json['kebab_place_id'],
      comment: json['comment'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status,
      'user_id': userId,
      'kebab_place_id': kebabPlaceId,
      'comment': comment,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
