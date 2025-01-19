import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kula_mobile/Data/Models/user_model.dart';
import 'package:kula_mobile/Services/token_storage.dart';

class RegisterDataSource {
  final http.Client client;
  final String? apiUrl = dotenv.env['API_URL'];

  RegisterDataSource({required this.client});

  Future<UserModel> registerUser(
    String name,
    String email,
    String password,
    String passwordConfirm,
  ) async {
    if (apiUrl == null) {
      throw Exception('API URL is not set');
    }

    final response = await client.post(
      Uri.parse('$apiUrl/register'),
      body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirm,
      },
    );

    if (response.statusCode == 201) {
      final jsonResponse = json.decode(response.body);
      final token = jsonResponse['token'];

      await TokenStorage.saveToken(token);

      final user = UserModel.fromJson(jsonResponse['user']);
      user.token = token;
      return user;
    } else {
      throw Exception('Failed to register');
    }
  }
}
