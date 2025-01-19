import 'package:kula_mobile/Data/Data_sources/comment_data_source.dart';
import 'package:kula_mobile/Data/Models/comment_model.dart';

class CommentRepositoryImpl {
  final CommentDataSource commentDataSource;

  CommentRepositoryImpl({required this.commentDataSource});

  Future<List<CommentModel>> fetchComments(int kebabPlaceId) {
    return commentDataSource.fetchComments(kebabPlaceId);
  }

  Future<void> addComment(int kebabPlaceId, String content) {
    return commentDataSource.addComment(kebabPlaceId, content);
  }

  Future<void> editComment(int commentId, String content) {
    return commentDataSource.editComment(commentId, content);
  }

  Future<void> deleteComment(int commentId) {
    return commentDataSource.deleteComment(commentId);
  }
}
