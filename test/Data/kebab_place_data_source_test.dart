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
            'street': 'Street 1',
            'building_number': '1A',
            'latitude': '51.5074',
            'longitude': '0.1278',
            'google_maps_url': 'https://maps.google.com',
            'google_maps_rating': '4.5',
            'phone': '123456789',
            'website': 'https://kebabplace1.com',
            'email': 'info@kebabplace1.com',
            'fillings': '1,2,3',
            'sauces': '1,2,3',
            'opening_hours': '10:00-22:00',
            'year_of_establishment': '2020',
            'is_kraft': true,
            'image': 'image1.jpg',
            'created_at': '2020-01-01T00:00:00.000Z',
            'updated_at': '2020-01-01T00:00:00.000Z',
          },
          {
            'id': 2,
            'name': 'Kebab Place 2',
            'street': 'Street 2',
            'building_number': '2B',
            'latitude': '51.5074',
            'longitude': '0.1278',
            'google_maps_url': 'https://maps.google.com',
            'google_maps_rating': '4.0',
            'phone': '987654321',
            'website': 'https://kebabplace2.com',
            'email': 'info@kebabplace2.com',
            'fillings': '1,2,3',
            'sauces': '1,2,3',
            'opening_hours': '10:00-22:00',
            'year_of_establishment': '2021',
            'is_kraft': false,
            'image': 'image2.jpg',
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
