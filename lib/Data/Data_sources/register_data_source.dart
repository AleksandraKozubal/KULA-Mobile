import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kula_mobile/Data/Models/user_model.dart';

class RegisterDataSource {
  final http.Client client;
  final String? apiUrl = dotenv.env['API_URL'];

  RegisterDataSource({required this.client});

  Future<void> registerUser(String name, String email, String password, String passwordConfirm) async {
    final response = await client.post(
      Uri.parse('$apiUrl/register'),
      body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirm,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final token = jsonResponse['token'];
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('bearer_token', token);

      UserModel user = UserModel.fromJson(jsonResponse['user']);
      user.token = token;
    } else {
      throw Exception('Failed to register');
    }
  }
}