import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:kula_mobile/Data/Data_sources/login_data_source.dart';
import 'package:kula_mobile/Data/Models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'login_data_source_test.mocks.dart';

@GenerateNiceMocks([MockSpec<http.Client>()])
void main() {
  group('LoginDataSource', () {
    late MockClient mockClient;
    late LoginDataSource loginDataSource;

    setUp(() async {
      mockClient = MockClient();
      await dotenv.load(fileName: '.env');
      SharedPreferences.setMockInitialValues({}); // Add this line
      loginDataSource = LoginDataSource(client: mockClient);
    });

    test('login returns a UserModel on successful login', () async {
      const email = 'john.doe@example.com';
      const password = 'password';
      const apiUrl = 'http://10.0.2.2:63251/api';
      final responseJson = {
        'token': 'some_token',
        'user': {
          'id': 1,
          'name': 'John Doe',
          'email': email,
          'created_at': '2023-01-01T00:00:00.000Z',
          'updated_at': '2023-01-01T00:00:00.000Z',
        },
      };

      when(mockClient.post(
        Uri.parse('$apiUrl/login'),
        body: {
          'email': email,
          'password': password,
        },
      )).thenAnswer((_) async => http.Response(json.encode(responseJson), 200));

      final user = await loginDataSource.login(email, password);

      expect(user.id, 1);
      expect(user.name, 'John Doe');
      expect(user.email, email);
      expect(user.token, 'some_token');
      expect(user.createdAt, DateTime.parse('2023-01-01T00:00:00.000Z'));
      expect(user.updatedAt, DateTime.parse('2023-01-01T00:00:00.000Z'));
    });

    test('login throws an exception on failed login', () async {
      const email = 'john.doe@example.com';
      const password = 'password';
      const apiUrl = 'http://10.0.2.2:63251/api';

      when(mockClient.post(
        Uri.parse('$apiUrl/login'),
        body: {
          'email': email,
          'password': password,
        },
      )).thenAnswer((_) async => http.Response('Unauthorized', 401));

      expect(() => loginDataSource.login(email, password), throwsException);
    });

    test('login returns a UserModel instance', () async {
      const email = 'john.doe@example.com';
      const password = 'password';
      const apiUrl = 'http://10.0.2.2:63251/api';
      final responseJson = {
        'token': 'some_token',
        'user': {
          'id': 1,
          'name': 'John Doe',
          'email': email,
          'created_at': '2023-01-01T00:00:00.000Z',
          'updated_at': '2023-01-01T00:00:00.000Z',
        },
      };

      when(mockClient.post(
        Uri.parse('$apiUrl/login'),
        body: {
          'email': email,
          'password': password,
        },
      )).thenAnswer((_) async => http.Response(json.encode(responseJson), 200));

      final user = await loginDataSource.login(email, password);

      expect(user, isA<UserModel>());
    });
  });
}
