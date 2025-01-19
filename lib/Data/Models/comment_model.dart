class CommentModel {
  final int id;
  final String content;
  final int userId;
  final int kebabPlaceId;
  final bool isOwner;
  final String userName;

  CommentModel({
    required this.id,
    required this.content,
    required this.userId,
    required this.kebabPlaceId,
    required this.isOwner,
    required this.userName,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      content: json['content'],
      userId: json['user_id'],
      kebabPlaceId: json['kebab_place_id'],
      isOwner: json['is_owner'],
      userName: json['user_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'user_id': userId,
      'kebab_place_id': kebabPlaceId,
      'is_owner': isOwner,
      'user_name': userName,
    };
  }
}
