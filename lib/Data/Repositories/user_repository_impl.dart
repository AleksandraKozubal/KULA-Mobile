import 'package:kula_mobile/Data/Data_sources/register_data_source.dart';
import 'package:kula_mobile/Data/Data_sources/login_data_source.dart';
import 'package:kula_mobile/Data/Data_sources/logout_data_source.dart';
import 'package:kula_mobile/Data/Repositories/user_repository.dart';
import 'package:kula_mobile/Data/Models/user_model.dart';

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
  Future<UserModel> registerUser(String name, String email, String password,
      String passwordConfirm) async {
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        passwordConfirm.isEmpty) {
      throw ArgumentError('All fields are required');
    }
    return await registerDataSource.registerUser(
        name, email, password, passwordConfirm);
  }

  @override
  Future<UserModel> loginUser(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw ArgumentError('Email and password are required');
    }
    return await loginDataSource.login(email, password);
  }

  @override
  Future<void> logoutUser() async {
    await logoutDataSource.logout();
  }
}
