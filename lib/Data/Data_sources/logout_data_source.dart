import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LogoutDataSource {
  final http.Client client;
  final String? apiUrl = dotenv.env['API_URL'];

  LogoutDataSource({required this.client});

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('bearer_token');

    final response = await client.post(
      Uri.parse('$apiUrl/logout'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      await prefs.remove('bearer_token');
      return;
    } else {
      throw Exception('Failed to logout');
    }
  }
}
