import 'package:flutter_test/flutter_test.dart';
import 'package:kula_mobile/Data/Models/filling_model.dart';

void main() {
  group('FillingModel', () {
    test('fromJson should return a valid model', () {
      final json = {
        'id': 1,
        'name': 'Chocolate',
        'is_vegan': '1',
        'hex_color': '#FFFFFF',
        'created_at': '2023-01-01T00:00:00.000Z',
        'updated_at': '2023-01-02T00:00:00.000Z',
      };

      final model = FillingModel.fromJson(json);

      expect(model.id, 1);
      expect(model.name, 'Chocolate');
      expect(model.isVegan, true);
      expect(model.hexColor, '#FFFFFF');
      expect(model.createdAt, DateTime.parse('2023-01-01T00:00:00.000Z'));
      expect(model.updatedAt, DateTime.parse('2023-01-02T00:00:00.000Z'));
    });

    test('toJson should return a valid json', () {
      final model = FillingModel(
        id: 1,
        name: 'Chocolate',
        isVegan: true,
        hexColor: '#FFFFFF',
        createdAt: DateTime.parse('2023-01-01T00:00:00.000Z'),
        updatedAt: DateTime.parse('2023-01-02T00:00:00.000Z'),
      );

      final json = model.toJson();

      expect(json['id'], 1);
      expect(json['name'], 'Chocolate');
      expect(json['is_vegan'], '1');
      expect(json['hex_color'], '#FFFFFF');
      expect(json['created_at'], '2023-01-01T00:00:00.000Z');
      expect(json['updated_at'], '2023-01-02T00:00:00.000Z');
    });

    test('fromJson should handle null dates', () {
      final json = {
        'id': 1,
        'name': 'Chocolate',
        'is_vegan': '1',
        'hex_color': '#FFFFFF',
        'created_at': null,
        'updated_at': null,
      };

      final model = FillingModel.fromJson(json);

      expect(model.createdAt, null);
      expect(model.updatedAt, null);
    });

    test('toJson should handle null dates', () {
      final model = FillingModel(
        id: 1,
        name: 'Chocolate',
        isVegan: true,
        hexColor: '#FFFFFF',
        createdAt: null,
        updatedAt: null,
      );

      final json = model.toJson();

      expect(json['created_at'], null);
      expect(json['updated_at'], null);
    });
  });
}
