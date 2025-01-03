import 'package:flutter_test/flutter_test.dart';
import 'package:kula_mobile/Data/Models/kebab_place_model.dart';

void main() {
  group('KebabPlaceModel', () {
    test('fromJson should return a valid model', () {
      final json = {
        'id': 1,
        'name': 'Test Kebab Place',
        'street': 'Test Street',
        'building_number': '123',
        'latitude': '12.345678',
        'longitude': '98.765432',
        'google_maps_url': 'http://maps.google.com',
        'google_maps_rating': '4.5',
        'phone': '1234567890',
        'website': 'http://test.com',
        'email': 'test@test.com',
        'fillings': 'Test fillings',
        'sauces': 'Test sauces',
        'opening_hours': '9 AM - 9 PM',
        'year_of_establishment': '2000',
        'is_kraft': true,
        'image': 'http://test.com/image.jpg',
        'created_at': '2023-01-01T00:00:00.000Z',
        'updated_at': '2023-01-02T00:00:00.000Z',
      };

      final kebabPlace = KebabPlaceModel.fromJson(json);

      expect(kebabPlace.id, 1);
      expect(kebabPlace.name, 'Test Kebab Place');
      expect(kebabPlace.street, 'Test Street');
      expect(kebabPlace.buildingNumber, '123');
      expect(kebabPlace.latitude, '12.345678');
      expect(kebabPlace.longitude, '98.765432');
      expect(kebabPlace.googleMapsUrl, 'http://maps.google.com');
      expect(kebabPlace.googleMapsRating, '4.5');
      expect(kebabPlace.phone, '1234567890');
      expect(kebabPlace.website, 'http://test.com');
      expect(kebabPlace.email, 'test@test.com');
      expect(kebabPlace.fillings, 'Test fillings');
      expect(kebabPlace.sauces, 'Test sauces');
      expect(kebabPlace.openingHours, '9 AM - 9 PM');
      expect(kebabPlace.yearEstablished, '2000');
      expect(kebabPlace.isKraft, true);
      expect(kebabPlace.image, 'http://test.com/image.jpg');
      expect(kebabPlace.createdAt, DateTime.parse('2023-01-01T00:00:00.000Z'));
      expect(kebabPlace.updatedAt, DateTime.parse('2023-01-02T00:00:00.000Z'));
    });

    test('toJson should return a valid json', () {
      final kebabPlace = KebabPlaceModel(
        id: 1,
        name: 'Test Kebab Place',
        street: 'Test Street',
        buildingNumber: '123',
        latitude: '12.345678',
        longitude: '98.765432',
        googleMapsUrl: 'http://maps.google.com',
        googleMapsRating: '4.5',
        phone: '1234567890',
        website: 'http://test.com',
        email: 'test@test.com',
        fillings: 'Test fillings',
        sauces: 'Test sauces',
        openingHours: '9 AM - 9 PM',
        yearEstablished: '2000',
        isKraft: true,
        image: 'http://test.com/image.jpg',
        createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2023-01-02T00:00:00.000Z'),
      );

      final json = kebabPlace.toJson();

      expect(json['id'], 1);
      expect(json['name'], 'Test Kebab Place');
      expect(json['street'], 'Test Street');
      expect(json['building_number'], '123');
      expect(json['latitude'], '12.345678');
      expect(json['longitude'], '98.765432');
      expect(json['google_maps_url'], 'http://maps.google.com');
      expect(json['google_maps_rating'], '4.5');
      expect(json['phone'], '1234567890');
      expect(json['website'], 'http://test.com');
      expect(json['email'], 'test@test.com');
      expect(json['fillings'], 'Test fillings');
      expect(json['sauces'], 'Test sauces');
      expect(json['opening_hours'], '9 AM - 9 PM');
      expect(json['year_established'], '2000');
      expect(json['is_kraft'], true);
      expect(json['image'], 'http://test.com/image.jpg');
      expect(json['created_at'], '2023-01-01T00:00:00.000Z');
      expect(json['updated_at'], '2023-01-02T00:00:00.000Z');
    });
  });
}
