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
