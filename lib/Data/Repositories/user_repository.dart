abstract class UserRepository {
  Future<void> registerUser(String name, String email, String password, String passwordConfirm);
  Future<Map<String, dynamic>> loginUser(String email, String password);
  Future<void> logoutUser();
}
