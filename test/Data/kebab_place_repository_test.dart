import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:kula_mobile/Data/Data_sources/kebab_place_data_source.dart';
import 'package:kula_mobile/Data/Repositories/kebab_place_repository_impl.dart';
import 'package:kula_mobile/Data/Models/kebab_place_model.dart';

@GenerateMocks([KebabPlaceDataSource])
import 'kebab_place_repository_test.mocks.dart';

void main() {
  group('KebabPlaceRepository', () {
    late KebabPlaceRepositoryImpl repository;
    late MockKebabPlaceDataSource mockDataSource;

    setUp(() {
      mockDataSource = MockKebabPlaceDataSource();
      repository = KebabPlaceRepositoryImpl(mockDataSource);
    });

    test(
        'getKebabPlaces returns a list of kebab places if the data source call completes successfully',
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
            'opened_at_year': '2020',
            'closed_at_year': '2021',
            'opening_hours': [
              {'day': 'Poniedzialek', 'from': '07:00', 'to': '20:00'},
              {'day': 'Wtorek', 'from': '07:00', 'to': '20:00'},
              {'day': 'Sroda', 'from': '07:00', 'to': '20:00'},
              {'day': 'Czwartek', 'from': '07:00', 'to': '20:00'},
              {'day': 'Piatek', 'from': '07:00', 'to': '20:00'},
              {'day': 'Sobota', 'from': '08:00', 'to': '23:00'},
              {'day': 'Niedziela', 'from': '08:00', 'to': '23:00'},
            ],
            'fillings': ['1', '2', '3'],
            'sauces': [1, 2, 3],
            'status': '1',
            'is_craft': true,
            'is_chain_restaurant': false,
            'location_type': '1',
            'order_options': ['phone', 'app', 'website', 'pyszne', 'ubereats'],
            'social_media': [
              {'Name': 'Facebook', 'url': 'https://facebook.com'},
              {'Name': 'Instagram', 'url': 'https://instagram.com'},
              {'Name': 'Twitter', 'url': 'https://twitter.com'},
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
            'opened_at_year': '2020',
            'closed_at_year': '2021',
            'opening_hours': [
              {'day': 'Poniedzialek', 'from': '07:00', 'to': '20:00'},
              {'day': 'Wtorek', 'from': '07:00', 'to': '20:00'},
              {'day': 'Sroda', 'from': '07:00', 'to': '20:00'},
              {'day': 'Czwartek', 'from': '07:00', 'to': '20:00'},
              {'day': 'Piatek', 'from': '07:00', 'to': '20:00'},
              {'day': 'Sobota', 'from': '08:00', 'to': '23:00'},
              {'day': 'Niedziela', 'from': '08:00', 'to': '23:00'},
            ],
            'fillings': ['1', '2', '3'],
            'sauces': ['1', '2', '3'],
            'status': '1',
            'is_craft': true,
            'is_chain_restaurant': false,
            'location_type': '1',
            'order_options': ['phone', 'app', 'website', 'pyszne', 'ubereats'],
            'social_media': [
              {'Name': 'Facebook', 'url': 'https://facebook.com'},
              {'Name': 'Instagram', 'url': 'https://instagram.com'},
              {'Name': 'Twitter', 'url': 'https://twitter.com'},
            ],
            'created_at': '2021-01-01T00:00:00.000Z',
            'updated_at': '2021-01-01T00:00:00.000Z',
          },
        ],
        'last_page': 1,
        'total': 2,
      };

      when(mockDataSource.getKebabPlaces(page: 1))
          .thenAnswer((_) async => mockResponse);

      final result = await repository.getKebabPlaces(page: 1);
      final data = result['data'] as List<Map<String, dynamic>>;

      expect(data, isA<List<Map<String, dynamic>>>());
      expect(data.length, 2);
      expect(data[0]['name'], 'Kebab Place 1');
      expect(data[1]['name'], 'Kebab Place 2');
    });

    test(
        'getKebabPlaces throws an exception if the data source call completes with an error',
        () async {
      when(mockDataSource.getKebabPlaces(page: 1))
          .thenThrow(Exception('Failed to load kebab places'));

      expect(() => repository.getKebabPlaces(page: 1), throwsException);
    });

    test(
        'getKebabPlace returns a kebab place if the data source call completes successfully',
        () async {
      final mockResponse = {
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
          {'Name': 'Facebook', 'url': 'https://facebook.com'},
          {'Name': 'Instagram', 'url': 'https://instagram.com'},
          {'Name': 'Twitter', 'url': 'https://twitter.com'},
        ],
        'created_at': '2021-01-01T00:00:00.000Z',
        'updated_at': '2021-01-01T00:00:00.000Z',
      };

      when(mockDataSource.getKebabPlace(1))
          .thenAnswer((_) async => KebabPlaceModel.fromJson(mockResponse));

      final result = await repository.getKebabPlace(1);

      expect(result, isA<KebabPlaceModel>());
      expect(result.name, 'Kebab Place 1');
    });

    test(
        'getKebabPlace throws an exception if the data source call completes with an error',
        () async {
      when(mockDataSource.getKebabPlace(1))
          .thenThrow(Exception('Failed to load kebab place'));

      expect(() => repository.getKebabPlace(1), throwsException);
    });
  });
}
