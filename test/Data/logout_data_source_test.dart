import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:kula_mobile/Data/Data_sources/logout_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateMocks([http.Client])
import 'logout_data_source_test.mocks.dart';

void main() {
  group('LogoutDataSource', () {
    late MockClient client;
    late LogoutDataSource logoutDataSource;

    setUp(() async {
      client = MockClient();
      await dotenv.load(fileName: '.env');
      logoutDataSource = LogoutDataSource(client: client);
      SharedPreferences.setMockInitialValues({'bearer_token': 'some_token'});
    });

    test('logout clears bearer token on successful logout', () async {
      when(client.post(
        any,
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('', 200));

      await logoutDataSource.logout();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('bearer_token'), isNull);
    });

    test('logout throws exception on failed logout', () async {
      when(client.post(
        any,
        headers: anyNamed('headers'),
      )).thenAnswer((_) async => http.Response('Unauthorized', 401));

      expect(
        () async => await logoutDataSource.logout(),
        throwsException,
      );
    });
  });
}
