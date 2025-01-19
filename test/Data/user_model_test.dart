import 'package:flutter_test/flutter_test.dart';
import 'package:kula_mobile/Data/Models/user_model.dart';

void main() {
  group('UserModel', () {
    test('fromJson creates a valid UserModel object', () {
      final json = {
        'id': 1,
        'name': 'John Doe',
        'email': 'john.doe@example.com',
        'token': 'some_token',
      };

      final user = UserModel.fromJson(json);

      expect(user.id, 1);
      expect(user.name, 'John Doe');
      expect(user.email, 'john.doe@example.com');
      expect(user.token, 'some_token');
    });

    test('toJson returns a valid JSON map', () {
      final user = UserModel(
        id: 1,
        name: 'John Doe',
        email: 'john.doe@example.com',
        token: 'some_token',
      );

      final json = user.toJson();

      expect(json['id'], 1);
      expect(json['name'], 'John Doe');
      expect(json['email'], 'john.doe@example.com');
      expect(json['token'], 'some_token');
    });
  });
}
