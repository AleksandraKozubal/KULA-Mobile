import 'package:kula_mobile/Data/Data_sources/register_data_source.dart';
import 'package:kula_mobile/Data/Data_sources/login_data_source.dart';
import 'package:kula_mobile/Data/Data_sources/logout_data_source.dart';
import 'package:kula_mobile/Data/Repositories/user_repository.dart';
import 'package:kula_mobile/Data/Models/user_model.dart';
import 'package:kula_mobile/Data/Data_sources/user_data_source.dart';
import 'package:kula_mobile/Services/token_storage.dart';

class UserRepositoryImpl implements UserRepository {
  final RegisterDataSource registerDataSource;
  final LoginDataSource loginDataSource;
  final LogoutDataSource logoutDataSource;
  final UserDataSource userDataSource;

  UserRepositoryImpl({
    required this.registerDataSource,
    required this.loginDataSource,
    required this.logoutDataSource,
    required this.userDataSource,
  });

  @override
  Future<UserModel> registerUser(
    String name,
    String email,
    String password,
    String passwordConfirm,
  ) async {
    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        passwordConfirm.isEmpty) {
      throw ArgumentError('All fields are required');
    }
    return await registerDataSource.registerUser(
      name,
      email,
      password,
      passwordConfirm,
    );
  }

  @override
  Future<UserModel> loginUser(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw ArgumentError('Email and password are required');
    }
    final token = await loginDataSource.login(email, password);
    await TokenStorage.saveToken(token);
    return await userDataSource.getUserData(token);
  }

  @override
  Future<void> logoutUser() async {
    final token = await TokenStorage.getToken();
    await logoutDataSource.logout(token);
  }
}
