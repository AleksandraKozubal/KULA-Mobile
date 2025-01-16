import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kula_mobile/Data/Models/user_model.dart';

class LoginDataSource {
  final http.Client client;
  final String? apiUrl = dotenv.env['API_URL'];

  LoginDataSource({required this.client});

  Future<Map<String, dynamic>> login(String email, String password) async {
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
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('bearer_token', token);

      UserModel user = UserModel.fromJson(jsonResponse['user']);
      user.token = token;

      return {
        'data': jsonResponse,
      };
    } else {
      throw Exception('Failed to login');
    }
  }

}
