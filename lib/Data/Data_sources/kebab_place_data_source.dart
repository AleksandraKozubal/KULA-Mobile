import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kula_mobile/Data/Models/kebab_place_model.dart';
import 'package:http/http.dart' as http;

class KebabPlaceDataSource {
  final String? apiUrl = dotenv.env['API_URL'];

  Future<List<KebabPlaceModel>> getKebabPlaces() async {
    final response = await http.get('$apiUrl/kebab-places' as Uri);
    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => KebabPlaceModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load kebab places');
    }
  }

  Future<KebabPlaceModel> getKebabPlace(int id) async {
    final response = await http.get('$apiUrl/kebab-places/$id' as Uri);
    if (response.statusCode == 200) {
      json.decode(response.body);
      return KebabPlaceModel.fromJson(json as Map<String, dynamic>);
    } else {
      throw Exception('Failed to load kebab place');
    }
  }


}