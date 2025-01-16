import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kula_mobile/Services/token_storage.dart';

class LoginDataSource {
  final http.Client client;
  final String? apiUrl = dotenv.env['API_URL'];

  LoginDataSource({required this.client});

  Future<String> login(String email, String password) async {
    if (apiUrl == null) {
      throw Exception('API URL is not set');
    }

    final response = await client.post(
      Uri.parse('$apiUrl/login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final token = jsonResponse['token'];

      await TokenStorage.saveToken(token);

      return token;
    } else {
      throw Exception('Failed to login');
    }
  }
}
