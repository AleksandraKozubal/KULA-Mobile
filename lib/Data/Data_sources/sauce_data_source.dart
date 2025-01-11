import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kula_mobile/Data/Models/sauce_model.dart';

class SauceDataSource {
  final http.Client client;
  final String? apiUrl = dotenv.env['API_URL'];

  SauceDataSource({required this.client});

  Future<List<SauceModel>> getSauces() async {
    final response = await client.get(Uri.parse('$apiUrl/sauces'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => SauceModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load sauces');
    }
  }
}
