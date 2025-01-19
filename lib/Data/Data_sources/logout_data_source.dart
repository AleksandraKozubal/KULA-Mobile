import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:kula_mobile/Services/token_storage.dart';

class LogoutDataSource {
  final http.Client client;
  final String? apiUrl = dotenv.env['API_URL'];

  LogoutDataSource({required this.client});

  Future<void> logout(String? token) async {
    if (apiUrl == null) {
      throw Exception('API URL is not set');
    }

    final response = await client.post(
      Uri.parse('$apiUrl/logout'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      await TokenStorage.clearToken();
      return;
    } else if (response.statusCode == 401) {
      await TokenStorage.clearToken();
      return;
    } else {
      throw Exception('Failed to logout');
    }
  }
}
