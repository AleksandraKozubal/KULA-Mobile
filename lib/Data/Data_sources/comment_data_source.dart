import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kula_mobile/Data/Models/comment_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kula_mobile/Services/token_storage.dart';

class CommentDataSource {
  final String baseUrl = dotenv.env['API_URL']!;

  Future<List<CommentModel>> fetchComments(int kebabPlaceId) async {
    final token = await TokenStorage.getToken();
    final headers = token != null
        ? {
            'Authorization': 'Bearer $token',
          }
        : {};
    final response = await http.get(
      Uri.parse('$baseUrl/kebab-places/$kebabPlaceId'),
      headers: headers.cast<String, String>(),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> kebabPlaceJson = json.decode(response.body);
      final List<dynamic> commentsJson = kebabPlaceJson['comments'];
      return commentsJson.map((json) => CommentModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<void> addComment(int kebabPlaceId, String content) async {
    final token = await TokenStorage.getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/kebab-places/$kebabPlaceId/comment?content=$content'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add comment');
    }
  }

  Future<void> editComment(int commentId, String content) async {
    final token = await TokenStorage.getToken();
    final response = await http.patch(
      Uri.parse('$baseUrl/comment/$commentId?content=$content'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to edit comment');
    }
  }

  Future<void> deleteComment(int commentId) async {
    final token = await TokenStorage.getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/comment/$commentId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete comment');
    }
  }
}
