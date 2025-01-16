import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:kula_mobile/Data/Data_sources/login_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

@GenerateMocks([http.Client])
import 'login_data_source_test.mocks.dart';

void main() {
  group('LoginDataSource', () {
    late MockClient client;
    late LoginDataSource loginDataSource;

    setUp(() async {
      client = MockClient();
      await dotenv.load(fileName: '.env');
      loginDataSource = LoginDataSource(client: client);
      SharedPreferences.setMockInitialValues({});
    });

    test('login returns user data on successful login', () async {
      final response = {
        'token': 'some_token',
        'user': {
          'id': 1,
          'name': 'John Doe',
          'email': 'john.doe@example.com',
        },
      };

      when(client.post(
        any,
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(json.encode(response), 200));

      final result = await loginDataSource.login('john.doe@example.com', 'password');

      expect(result['data']['token'], 'some_token');
      expect(result['data']['user']['name'], 'John Doe');

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('bearer_token'), 'some_token');
    });

    test('login throws exception on failed login', () async {
      when(client.post(
        any,
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Unauthorized', 401));

      expect(
        () async => await loginDataSource.login('john.doe@example.com', 'wrong_password'),
        throwsException,
      );
    });
  });
}
