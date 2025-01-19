import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kula_mobile/Data/Models/suggestion_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kula_mobile/Services/token_storage.dart';

class SuggestionDataSource {
  final String baseUrl = dotenv.env['API_URL']!;

  Future<List<SuggestionModel>> fetchSuggestions() async {
    final token = await TokenStorage.getToken();
    final headers = token != null
        ? {
            'Authorization': 'Bearer $token',
          }
        : {};
    final response = await http.get(
      Uri.parse('$baseUrl/mysuggestions'),
      headers: headers.cast<String, String>(),
    );
    if (response.statusCode == 200) {
      final List<dynamic> suggestionsJson = json.decode(response.body);
      return suggestionsJson
          .map((json) => SuggestionModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  Future<void> addSuggestion(
    int kebabPlaceId,
    String name,
    String description,
  ) async {
    final token = await TokenStorage.getToken();
    final response = await http.post(
      Uri.parse(
        '$baseUrl/kebab-places/$kebabPlaceId/suggest?name=$name&description=$description&kebabPlace=$kebabPlaceId',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add suggestion');
    }
  }
}
