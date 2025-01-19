import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:kula_mobile/Data/Data_sources/register_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

@GenerateMocks([http.Client])
import 'register_data_source_test.mocks.dart';

void main() {
  group('RegisterDataSource', () {
    late MockClient client;
    late RegisterDataSource registerDataSource;

    setUp(() async {
      client = MockClient();
      await dotenv.load(fileName: '.env');
      registerDataSource = RegisterDataSource(client: client);
      SharedPreferences.setMockInitialValues({});
    });

    test('registerUser saves bearer token on successful registration',
        () async {
      final response = {
        'token': 'some_token',
        'user': {
          'id': 1,
          'name': 'John Doe',
          'email': 'john.doe@example.com',
        },
      };

      when(
        client.post(
          any,
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response(json.encode(response), 201));

      await registerDataSource.registerUser(
        'John Doe',
        'john.doe@example.com',
        'password',
        'password',
      );

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('bearer_token'), 'some_token');
    });

    test('registerUser throws exception on failed registration', () async {
      when(
        client.post(
          any,
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => http.Response('Bad Request', 401));

      expect(
        () async => await registerDataSource.registerUser(
          'John Doe',
          'john.doe@example.com',
          'password',
          'password',
        ),
        throwsException,
      );
    });
  });
}
