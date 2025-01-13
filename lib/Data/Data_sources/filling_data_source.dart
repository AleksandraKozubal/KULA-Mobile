import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kula_mobile/Data/Models/filling_model.dart';

class FillingDataSource {
  final http.Client client;
  final String? apiUrl = dotenv.env['API_URL'];

  FillingDataSource({required this.client});

  Future<List<FillingModel>> getFillings() async {
    final response = await client.get(Uri.parse('$apiUrl/fillings'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => FillingModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load fillings');
    }
  }
}
