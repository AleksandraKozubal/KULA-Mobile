import 'package:kula_mobile/Data/Data_sources/register_data_source.dart';
import 'package:kula_mobile/Data/Data_sources/login_data_source.dart';
import 'package:kula_mobile/Data/Data_sources/logout_data_source.dart';
import 'package:kula_mobile/Data/Repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final RegisterDataSource registerDataSource;
  final LoginDataSource loginDataSource;
  final LogoutDataSource logoutDataSource;

  UserRepositoryImpl({
    required this.registerDataSource,
    required this.loginDataSource,
    required this.logoutDataSource,
  });

  @override
  Future<void> registerUser(String name, String email, String password, String passwordConfirm) async {
    await registerDataSource.registerUser(name, email, password, passwordConfirm);
  }

  @override
  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    return await loginDataSource.login(email, password);
  }

  @override
  Future<void> logoutUser() async {
    await logoutDataSource.logout();
  }

}
