import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kula_mobile/Data/Models/kebab_place_model.dart';
import 'package:http/http.dart' as http;

class KebabPlaceDataSource {
  final String? apiUrl = dotenv.env['API_URL'];

  Future<List<KebabPlaceModel>> getKebabPlaces() async {
    final response = await http.get(Uri.parse('$apiUrl/kebab-places'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'];
      return data.map((json) => KebabPlaceModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load kebab places');
    }
  }

  Future<KebabPlaceModel> getKebabPlace(int id) async {
    final response = await http.get(Uri.parse('$apiUrl/kebab-places/$id'));
    if (response.statusCode == 200) {
      json.decode(response.body);
      return KebabPlaceModel.fromJson(json as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load kebab place');
    }
  }

}