import 'package:flutter_test/flutter_test.dart';
import 'package:kula_mobile/Data/Models/sauce_model.dart';

void main() {
  group('SauceModel', () {
    test('fromJson should return a valid model', () {
      final json = {
        'id': 1,
        'name': 'Hot Sauce',
        'hex_color': '#FF5733',
        'created_at': '2023-01-01T00:00:00.000Z',
        'updated_at': '2023-01-02T00:00:00.000Z',
      };

      final sauce = SauceModel.fromJson(json);

      expect(sauce.id, 1);
      expect(sauce.name, 'Hot Sauce');
      expect(sauce.hexColor, '#FF5733');
      expect(sauce.createdAt, DateTime.parse('2023-01-01T00:00:00.000Z'));
      expect(sauce.updatedAt, DateTime.parse('2023-01-02T00:00:00.000Z'));
    });

    test('toJson should return a valid json', () {
      final sauce = SauceModel(
        id: 1,
        name: 'Hot Sauce',
        hexColor: '#FF5733',
        createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2023-01-02T00:00:00.000Z'),
      );

      final json = sauce.toJson();

      expect(json['id'], 1);
      expect(json['name'], 'Hot Sauce');
      expect(json['hex_color'], '#FF5733');
      expect(json['created_at'], '2023-01-01T00:00:00.000Z');
      expect(json['updated_at'], '2023-01-02T00:00:00.000Z');
    });

    test('fromJson should handle null dates', () {
      final json = {
        'id': 2,
        'name': 'Mild Sauce',
        'hex_color': '#00FF00',
        'created_at': null,
        'updated_at': null,
      };

      final sauce = SauceModel.fromJson(json);

      expect(sauce.id, 2);
      expect(sauce.name, 'Mild Sauce');
      expect(sauce.hexColor, '#00FF00');
      expect(sauce.createdAt, null);
      expect(sauce.updatedAt, null);
    });

    test('toJson should handle null dates', () {
      final sauce = SauceModel(
        id: 2,
        name: 'Mild Sauce',
        hexColor: '#00FF00',
        createdAt: null,
        updatedAt: null,
      );

      final json = sauce.toJson();

      expect(json['id'], 2);
      expect(json['name'], 'Mild Sauce');
      expect(json['hex_color'], '#00FF00');
      expect(json['created_at'], null);
      expect(json['updated_at'], null);
    });
  });
}
