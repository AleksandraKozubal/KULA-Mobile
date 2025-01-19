import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kula_mobile/Services/token_storage.dart';

class FavoriteDataSource {
  final String baseUrl;

  FavoriteDataSource() : baseUrl = dotenv.env['API_URL']!;

  Future<bool> favoriteKebabPlace(String id) async {
    final token = await TokenStorage.getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/kebab-places/$id/fav'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print('Favorite response: ${response.statusCode} ${response.body}');
    if (response.statusCode == 409) {
      return false; // Conflict, already favorited
    } else if (response.statusCode != 201) {
      throw Exception('Failed to favorite kebab place');
    }
    return true;
  }

  Future<void> unfavoriteKebabPlace(String id) async {
    final token = await TokenStorage.getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/kebab-places/$id/unfav'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print('Unfavorite response: ${response.statusCode} ${response.body}');
    if (response.statusCode != 200) {
      throw Exception('Failed to unfavorite kebab place');
    }
  }

  Future<bool> isKebabPlaceFavorited(String id) async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/kebab-places/$id/is-favorited'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print('Is Favorited response: ${response.statusCode} ${response.body}');
    if (response.statusCode != 200) {
      throw Exception('Failed to check if kebab place is favorited');
    }
    return response.body == 'true';
  }
}
