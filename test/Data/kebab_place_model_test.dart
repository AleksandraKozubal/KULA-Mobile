import 'package:flutter_test/flutter_test.dart';
import 'package:kula_mobile/Data/Models/kebab_place_model.dart';

void main() {
  group('KebabPlaceModel', () {
    test('fromJson should return a valid model', () {
      final json = {
        'id': 1,
        'name': 'Test Kebab Place',
        'address': 'Test Street, 123',
        'latitude': '12.345678',
        'longitude': '98.765432',
        'google_maps_url': 'http://maps.google.com',
        'google_maps_rating': '4.5',
        'phone': '1234567890',
        'website': 'http://test.com',
        'email': 'test@test.com',
        'fillings': ['Test fillings'],
        'sauces': [1, 2, 3],
        'opening_hours': [
          {'day': 'Poniedzialek', 'from': '07:00', 'to': '20:00'},
        ],
        'status': 'open',
        'location_type': 'restaurant',
        'order_options': ['dine-in', 'takeaway'],
        'social_media': [
          {'Name': 'Facebook', 'url': 'http://facebook.com/test'},
        ],
        'is_craft': true,
        'image': 'http://test.com/image.jpg',
        'created_at': '2023-01-01T00:00:00.000Z',
        'updated_at': '2023-01-02T00:00:00.000Z',
      };

      final kebabPlace = KebabPlaceModel.fromJson(json);

      expect(kebabPlace.id, 1);
      expect(kebabPlace.name, 'Test Kebab Place');
      expect(kebabPlace.address, 'Test Street, 123');
      expect(kebabPlace.latitude, '12.345678');
      expect(kebabPlace.longitude, '98.765432');
      expect(kebabPlace.googleMapsUrl, 'http://maps.google.com');
      expect(kebabPlace.googleMapsRating, '4.5');
      expect(kebabPlace.phone, '1234567890');
      expect(kebabPlace.website, 'http://test.com');
      expect(kebabPlace.email, 'test@test.com');
      expect(kebabPlace.fillings, ['Test fillings']);
      expect(kebabPlace.sauces, [1, 2, 3]);
      expect(kebabPlace.openingHours, [
        {'day': 'Poniedzialek', 'from': '07:00', 'to': '20:00'},
      ]);
      expect(kebabPlace.status, 'open');
      expect(kebabPlace.locationType, 'restaurant');
      expect(kebabPlace.orderOptions, ['dine-in', 'takeaway']);
      expect(kebabPlace.socialMedia, [
        {'Name': 'Facebook', 'url': 'http://facebook.com/test'},
      ]);
      expect(kebabPlace.isCraft, true);
      expect(kebabPlace.image, 'http://test.com/image.jpg');
      expect(kebabPlace.createdAt, DateTime.parse('2023-01-01T00:00:00.000Z'));
      expect(kebabPlace.updatedAt, DateTime.parse('2023-01-02T00:00:00.000Z'));
    });

    test('toJson should return a valid json', () {
      final kebabPlace = KebabPlaceModel(
        id: 1,
        name: 'Test Kebab Place',
        address: 'Test Street, 123',
        latitude: '12.345678',
        longitude: '98.765432',
        googleMapsUrl: 'http://maps.google.com',
        googleMapsRating: '4.5',
        phone: '1234567890',
        website: 'http://test.com',
        email: 'test@test.com',
        fillings: [1],
        sauces: [1, 2, 3],
        openingHours: [
          {'day': 'Poniedzialek', 'from': '07:00', 'to': '20:00'},
        ],
        status: 'open',
        locationType: 'restaurant',
        orderOptions: ['dine-in', 'takeaway'],
        socialMedia: [
          {'Name': 'Facebook', 'url': 'http://facebook.com/test'},
        ],
        isCraft: true,
        image: 'http://test.com/image.jpg',
        createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2023-01-02T00:00:00.000Z'),
      );

      final json = kebabPlace.toJson();

      expect(json['id'], 1);
      expect(json['name'], 'Test Kebab Place');
      expect(json['address'], 'Test Street, 123');
      expect(json['latitude'], '12.345678');
      expect(json['longitude'], '98.765432');
      expect(json['google_maps_url'], 'http://maps.google.com');
      expect(json['google_maps_rating'], '4.5');
      expect(json['phone'], '1234567890');
      expect(json['website'], 'http://test.com');
      expect(json['email'], 'test@test.com');
      expect(json['fillings'], [1]);
      expect(json['sauces'], [1, 2, 3]);
      expect(json['opening_hours'], [
        {'day': 'Poniedzialek', 'from': '07:00', 'to': '20:00'},
      ]);
      expect(json['status'], 'open');
      expect(json['location_type'], 'restaurant');
      expect(json['order_options'], ['dine-in', 'takeaway']);
      expect(json['social_media'], [
        {'Name': 'Facebook', 'url': 'http://facebook.com/test'},
      ]);
      expect(json['is_craft'], true);
      expect(json['image'], 'http://test.com/image.jpg');
      expect(json['created_at'], '2023-01-01T00:00:00.000Z');
      expect(json['updated_at'], '2023-01-02T00:00:00.000Z');
    });

    test('should handle null values correctly', () {
      final json = {
        'id': 1,
        'name': 'Test Kebab Place',
        'address': 'Test Street, 123',
        'latitude': null,
        'longitude': null,
        'google_maps_url': null,
        'google_maps_rating': null,
        'phone': null,
        'website': null,
        'email': null,
        'fillings': null,
        'sauces': null,
        'opening_hours': null,
        'status': 'open',
        'location_type': 'restaurant',
        'order_options': ['dine-in', 'takeaway'],
        'social_media': null,
        'is_craft': null,
        'image': null,
        'created_at': null,
        'updated_at': null,
      };

      final kebabPlace = KebabPlaceModel.fromJson(json);

      expect(kebabPlace.id, 1);
      expect(kebabPlace.name, 'Test Kebab Place');
      expect(kebabPlace.address, 'Test Street, 123');
      expect(kebabPlace.latitude, null);
      expect(kebabPlace.longitude, null);
      expect(kebabPlace.googleMapsUrl, null);
      expect(kebabPlace.googleMapsRating, null);
      expect(kebabPlace.phone, null);
      expect(kebabPlace.website, null);
      expect(kebabPlace.email, null);
      expect(kebabPlace.fillings, []);
      expect(kebabPlace.sauces, []);
      expect(kebabPlace.openingHours, []);
      expect(kebabPlace.status, 'open');
      expect(kebabPlace.locationType, 'restaurant');
      expect(kebabPlace.orderOptions, ['dine-in', 'takeaway']);
      expect(kebabPlace.socialMedia, []);
      expect(kebabPlace.isCraft, null);
      expect(kebabPlace.image, null);
      expect(kebabPlace.createdAt, null);
      expect(kebabPlace.updatedAt, null);
    });
  });
}
