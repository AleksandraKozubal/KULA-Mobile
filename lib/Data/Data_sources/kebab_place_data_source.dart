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
    int? paginate,
    String? fchain,
    String? fcraft,
    String? fdatetime,
    List<int>? ffillings,
    String? flocation,
    String? fopen,
    String? fordering,
    List<int>? fsauces,
    String? fstatus,
    String? sby,
    String? sdirection,

  }) async {
    var url = '$apiUrl/kebab-places?page=$page';
    if (paginate != null) {
      url += '&paginate=$paginate';
    }
    if (fchain != null) {
      url += '&fchain=$fchain';
    }
    if (fcraft != null) {
      url += '&fcraft=$fcraft';
    }
    if (fdatetime != null) {
      url += '&fdatetime=$fdatetime';
    }
    if (ffillings != null) {
      url += '&ffillings=[${ffillings.join(',')}]';
    }
    if (flocation != null) {
      url += '&flocation=$flocation';
    }
    if (fopen != null) {
      url += '&fopen=$fopen';
    }
    if (fordering != null) {
      url += '&fordering=$fordering';
    }
    if (fsauces != null) {
      url += '&fsauces=[${fsauces.join(',')}]';
    }
    if (fstatus != null) {
      url += '&fstatus=$fstatus';
    }
    if (sby != null) {
      url += '&sby=$sby';
    }
    if (sdirection != null) {
      url += '&sdirection=$sdirection';
    }
    final response = await client.get(Uri.parse(url));
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
