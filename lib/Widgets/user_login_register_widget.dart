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

  Future<void> _submit() async {
    UserModel? user;
    try {
      if (_isLogin) {
        user = await _userRepository.loginUser(
          _emailController.text,
          _passwordController.text,
        );
      } else {
        if (_passwordController.text == _confirmPasswordController.text) {
          user = await _userRepository.registerUser(
            _nameController.text,
            _emailController.text,
            _passwordController.text,
            _confirmPasswordController.text,
          );
        } else {
          Navigator.of(context).pop();
          _showErrorDialog('Hasła się nie zgadzają');
          return;
        }
      }
      if (user.token != null) {
        await TokenStorage.saveToken(user.token!);
      }
      Navigator.of(context).pop();
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
      title: Text(_isLogin ? 'Logowanie' : 'Rejestracja'),
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
                    ? 'Nie masz konta? Zarejestruj się'
                    : 'Masz już konto? Zaloguj się',
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Anuluj'),
        ),
      ],
    );
  }
}
