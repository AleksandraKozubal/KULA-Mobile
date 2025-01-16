import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:kula_mobile/Data/Data_sources/logout_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'logout_data_source_test.mocks.dart';

@GenerateNiceMocks([MockSpec<http.Client>()])
void main() {
  group('LogoutDataSource', () {
    late MockClient mockClient;
    late LogoutDataSource logoutDataSource;

    setUp(() async {
      mockClient = MockClient();
      await dotenv.load(fileName: '.env');
      SharedPreferences.setMockInitialValues({});
      logoutDataSource = LogoutDataSource(client: mockClient);
    });

    test('logout clears token on successful logout', () async {
      const token = 'some_token';
      const apiUrl = 'http://10.0.2.2:63251/api';

      when(
        mockClient.post(
          Uri.parse('$apiUrl/logout'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      ).thenAnswer((_) async => http.Response('', 200));

      await logoutDataSource.logout(token);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('bearer_token'), isNull);
    });

    test('logout clears token on unauthorized logout', () async {
      const token = 'some_token';
      const apiUrl = 'http://10.0.2.2:63251/api';

      when(
        mockClient.post(
          Uri.parse('$apiUrl/logout'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      ).thenAnswer((_) async => http.Response('Unauthorized', 401));

      await logoutDataSource.logout(token);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('bearer_token'), isNull);
    });

    test('logout throws an exception on failed logout', () async {
      const token = 'some_token';
      const apiUrl = 'http://10.0.2.2:63251/api';

      when(
        mockClient.post(
          Uri.parse('$apiUrl/logout'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      ).thenAnswer((_) async => http.Response('Internal Server Error', 500));

      expect(() => logoutDataSource.logout(token), throwsException);
    });
  });
}
