import 'package:kula_mobile/Data/Models/user_model.dart';

abstract class UserRepository {
  Future<UserModel> registerUser(
      String name, String email, String password, String passwordConfirm);
  Future<UserModel> loginUser(String email, String password);
  Future<void> logoutUser();
}
