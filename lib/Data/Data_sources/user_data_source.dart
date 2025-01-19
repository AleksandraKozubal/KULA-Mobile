import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kula_mobile/Data/Models/user_model.dart';

class UserDataSource {
  final http.Client client;
  final String? apiUrl = dotenv.env['API_URL'];

  UserDataSource({required this.client});

  Future<UserModel> getUserData(String token) async {
    if (apiUrl == null) {
      throw Exception('API URL is not set');
    }

    final response = await client.get(
      Uri.parse('$apiUrl/user'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return UserModel.fromJson(jsonResponse);
    } else if (response.statusCode == 401) {
      return Future.error('User is not logged in');
    } else {
      throw Exception('Failed to load user data');
    }
  }
}
