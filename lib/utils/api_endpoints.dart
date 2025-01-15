import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndPoints {
  static final String? baseUrl = dotenv.env['API_URL'];
  static _AuthEndPoints authEndpoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String registerMail = '/register';
  final String loginEmail = '/login';
}
