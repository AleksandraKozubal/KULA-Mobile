import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:kula_mobile/Data/Data_sources/kebab_place_data_source.dart';
import 'package:kula_mobile/Data/Models/kebab_place_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

@GenerateMocks([http.Client])
import 'kebab_place_data_source_test.mocks.dart';

void main() {
  group('KebabPlaceDataSource', () {
    late KebabPlaceDataSource dataSource;
    late MockClient mockHttpClient;

    setUp(() async {
      mockHttpClient = MockClient();
      await dotenv.load(fileName: '.env');
      dataSource = KebabPlaceDataSource(client: mockHttpClient);
    });

    test(
        'getKebabPlaces returns a list of kebab places if the http call completes successfully',
        () async {
      final mockResponse = {
        'data': [
          {
            'id': 1,
            'name': 'Kebab Place 1',
            'image': null,
            'address': 'Street 1, 1A',
            'latitude': '51.5074',
            'longitude': '0.1278',
            'google_maps_url': 'https://maps.google.com',
            'google_maps_rating': '4.5',
            'phone': '123456789',
            'website': 'https://kebabplace1.com',
            'email': 'a@example.com',
            'opened_at_year': 2020,
            'closed_at_year': 2021,
            'opening_hours': [
              {'day': 'Poniedzialek', 'from': '07:00', 'to': '20:00'},
              {'day': 'Wtorek', 'from': '07:00', 'to': '20:00'},
              {'day': 'Sroda', 'from': '07:00', 'to': '20:00'},
              {'day': 'Czwartek', 'from': '07:00', 'to': '20:00'},
              {'day': 'Piatek', 'from': '07:00', 'to': '20:00'},
              {'day': 'Sobota', 'from': '08:00', 'to': '23:00'},
              {'day': 'Niedziela', 'from': '08:00', 'to': '23:00'},
            ],
            'fillings': [1, 2, 3],
            'sauces': [1, 2, 3],
            'status': '1',
            'is_craft': true,
            'is_chain_restaurant': false,
            'location_type': '1',
            'order_options': ['phone', 'app', 'website', 'pyszne', 'ubereats'],
            'social_media': [
              {'name': 'Facebook', 'url': 'https://facebook.com'},
              {'name': 'Instagram', 'url': 'https://instagram.com'},
              {'name': 'Twitter', 'url': 'https://twitter.com'},
            ],
            'created_at': '2021-01-01T00:00:00.000Z',
            'updated_at': '2021-01-01T00:00:00.000Z',
          },
          {
            'id': 2,
            'name': 'Kebab Place 2',
            'image': null,
            'address': 'Street 1, 1A',
            'latitude': '51.5074',
            'longitude': '0.1278',
            'google_maps_url': 'https://maps.google.com',
            'google_maps_rating': '4.5',
            'phone': '123456789',
            'website': 'https://kebabplace1.com',
            'email': 'a@example.com',
            'opened_at_year': 2020,
            'closed_at_year': 2021,
            'opening_hours': [
              {'day': 'Poniedzialek', 'from': '07:00', 'to': '20:00'},
              {'day': 'Wtorek', 'from': '07:00', 'to': '20:00'},
              {'day': 'Sroda', 'from': '07:00', 'to': '20:00'},
              {'day': 'Czwartek', 'from': '07:00', 'to': '20:00'},
              {'day': 'Piatek', 'from': '07:00', 'to': '20:00'},
              {'day': 'Sobota', 'from': '08:00', 'to': '23:00'},
              {'day': 'Niedziela', 'from': '08:00', 'to': '23:00'},
            ],
            'fillings': [1, 2, 3],
            'sauces': [1, 2, 3],
            'status': '1',
            'is_craft': true,
            'is_chain_restaurant': false,
            'location_type': '1',
            'order_options': ['phone', 'app', 'website', 'pyszne', 'ubereats'],
            'social_media': [
              {'name': 'Facebook', 'url': 'https://facebook.com'},
              {'name': 'Instagram', 'url': 'https://instagram.com'},
              {'name': 'Twitter', 'url': 'https://twitter.com'},
            ],
            'created_at': '2021-01-01T00:00:00.000Z',
            'updated_at': '2021-01-01T00:00:00.000Z',
          },
        ],
        'last_page': 1,
        'total': 2,
      };

      when(mockHttpClient.get(any)).thenAnswer(
        (_) async => http.Response(json.encode(mockResponse), 200),
      );

      final result = await dataSource.getKebabPlaces(page: 1);

      expect(result['data'], isA<List<KebabPlaceModel>>());
      expect(result['data'].length, 2);
      expect(result['data'][0].name, 'Kebab Place 1');
      expect(result['data'][1].name, 'Kebab Place 2');
    });

    test(
        'getKebabPlaces throws an exception if the http call completes with an error',
        () async {
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(() => dataSource.getKebabPlaces(page: 1), throwsException);
    });
  });
}
