import 'package:flutter/material.dart';
import 'package:kula_mobile/Data/Repositories/user_repository_impl.dart';
import 'package:kula_mobile/Data/Models/user_model.dart';
import 'package:kula_mobile/Data/Data_sources/register_data_source.dart';
import 'package:kula_mobile/Data/Data_sources/login_data_source.dart';
import 'package:kula_mobile/Data/Data_sources/logout_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:kula_mobile/Services/token_storage.dart';
import 'package:kula_mobile/Data/Data_sources/user_data_source.dart';

class UserLoginRegisterWidget extends StatefulWidget {
  const UserLoginRegisterWidget({super.key});

  @override
  UserLoginRegisterWidgetState createState() => UserLoginRegisterWidgetState();
}

class UserLoginRegisterWidgetState extends State<UserLoginRegisterWidget> {
  final UserRepositoryImpl _userRepository = UserRepositoryImpl(
    registerDataSource: RegisterDataSource(client: http.Client()),
    loginDataSource: LoginDataSource(client: http.Client()),
    logoutDataSource: LogoutDataSource(client: http.Client()),
    userDataSource: UserDataSource(client: http.Client()),
  );
  bool _isLogin = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _toggleForm() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  bool _validateEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  bool _validatePassword(String password) {
    if (password.length < 8) return false;
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigit = password.contains(RegExp(r'\d'));
    final hasSpecialCharacter =
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    final validConditions = [
      hasUppercase,
      hasLowercase,
      hasDigit,
      hasSpecialCharacter,
    ].where((c) => c).length;
    return validConditions >= 3;
  }

  Future<void> _submit() async {
    if (!_validateEmail(_emailController.text.trim().toLowerCase())) {
      _showErrorDialog('Nieprawidłowy format email');
      return;
    }
    if (!_validatePassword(_passwordController.text)) {
      _showErrorDialog(
        _isLogin
            ? 'Nieprawidłowe hasło'
            : 'Hasło musi zawierać co najmniej 8 znaków, w tym 3 z 4 wymagań: 1 wielka litera, 1 mała litera, 1 cyfra i 1 znak specjalny',
      );
      return;
    }
    if (!_isLogin && _nameController.text.trim().isEmpty) {
      _showErrorDialog('Nazwa użytkownika jest wymagana');
      return;
    }
    if (!_isLogin &&
        _passwordController.text != _confirmPasswordController.text) {
      _showErrorDialog('Hasła się nie zgadzają');
      return;
    }

    UserModel? user;
    try {
      if (_isLogin) {
        user = await _userRepository.loginUser(
          _emailController.text.trim().toLowerCase(),
          _passwordController.text,
        );
      } else {
        user = await _userRepository.registerUser(
          _nameController.text.trim(),
          _emailController.text.trim().toLowerCase(),
          _passwordController.text,
          _confirmPasswordController.text,
        );
      }
      if (user.token != null) {
        await TokenStorage.saveToken(user.token!);
      }
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isLogin ? 'Zalogowano pomyślnie' : 'Zarejestrowano pomyślnie',
          ),
        ),
      );
    } catch (e) {
      Navigator.of(context).pop();
      _showErrorDialog(
        _isLogin ? 'Nie udało się zalogować' : 'Nie udało się zarejestrować',
      );
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Błąd'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(_isLogin ? 'Logowanie' : 'Rejestracja'),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (!_isLogin)
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nazwa użytkownika',
                ),
              ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Hasło',
              ),
              obscureText: true,
            ),
            if (!_isLogin)
              TextField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Potwierdź hasło',
                ),
                obscureText: true,
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: Text(_isLogin ? 'Zaloguj się' : 'Zarejestruj się'),
            ),
            TextButton(
              onPressed: _toggleForm,
              child: Text(
                _isLogin
                    ? 'Nie masz konta?\nZarejestruj się'
                    : 'Masz już konto?\nZaloguj się',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
