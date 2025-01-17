import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kula_mobile/Data/Models/kebab_place_model.dart';
import 'package:http/http.dart' as http;

class KebabPlaceDataSource {
  final http.Client client;
  final String? apiUrl = dotenv.env['API_URL'];

  KebabPlaceDataSource({required this.client});

  Future<Map<String, dynamic>> getKebabPlaces({
    int page = 1,
    String? sby,
    String? sdirection,
    String? ffillings,
    String? fsauces,
    bool? fkraft,
    int? paginate,
  }) async {

    final response = await client.get(
      Uri.parse(
        '$apiUrl/kebab-places?page=$page${sby != null ? '&sby=$sby' : ''}${sdirection != null ? '&sdirection=$sdirection' : ''}${ffillings != null ? '&ffillings=$ffillings' : ''}${fsauces != null ? '&fsauces=$fsauces' : ''}${fkraft != null ? '&fkraft=$fkraft' : ''}${paginate != null ? '&paginate=$paginate' : ''}',
      ),
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> data = jsonResponse['data'];
      final kebabPlaces =
          data.map((json) => KebabPlaceModel.fromJson(json)).toList();
      return {
        'data': kebabPlaces,
        'next_page_url': jsonResponse['next_page_url'],
        'last_page': jsonResponse['last_page'],
        'total': jsonResponse['total'],
      };
    } else {
      throw Exception('Failed to load kebab places');
    }
  }

  Future<KebabPlaceModel> getKebabPlace(int id) async {
    final response = await client.get(Uri.parse('$apiUrl/kebab-places/$id'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return KebabPlaceModel.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load kebab place');
    }
  }
}
