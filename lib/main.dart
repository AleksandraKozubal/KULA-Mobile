import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:kula_mobile/Data/Data_sources/filling_data_source.dart';
import 'package:kula_mobile/Data/Data_sources/login_data_source.dart';
import 'package:kula_mobile/Data/Data_sources/sauce_data_source.dart';
import 'package:kula_mobile/Data/Repositories/filling_repository_impl.dart';
import 'package:kula_mobile/Data/Data_sources/logout_data_source.dart';
import 'package:kula_mobile/Data/Data_sources/register_data_source.dart';
import 'package:kula_mobile/Data/Repositories/sauce_repository_impl.dart';
import 'Widgets/kebab_place_widget.dart';
import 'Widgets/kebab_place_map_widget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'Widgets/user_login_register_widget.dart';
import 'package:kula_mobile/Services/token_storage.dart';
import 'package:kula_mobile/Data/Models/user_model.dart';
import 'package:kula_mobile/Data/Repositories/user_repository_impl.dart';
import 'package:kula_mobile/Data/Data_sources/user_data_source.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Widgets/suggestion_widget.dart';

Future<void> main() async {
  await dotenv.load();
  debugPaintSizeEnabled = false;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkTheme = false;
  UserModel? _loggedInUser;
  final UserRepositoryImpl _userRepository = UserRepositoryImpl(
    registerDataSource: RegisterDataSource(client: http.Client()),
    loginDataSource: LoginDataSource(client: http.Client()),
    logoutDataSource: LogoutDataSource(client: http.Client()),
    userDataSource: UserDataSource(client: http.Client()),
  );

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _loadTheme();
    _checkLoggedInUser();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    });
  }

  Future<void> _saveTheme(bool isDarkTheme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkTheme', isDarkTheme);
  }

  Future<void> _checkLoggedInUser() async {
    final token = await TokenStorage.getToken();
    if (token != null) {
      try {
        final user = await _userRepository.userDataSource.getUserData(token);
        setState(() {
          _loggedInUser = user;
        });
      } catch (e) {
        await TokenStorage.clearToken();
        setState(() {
          _loggedInUser = null;
        });
      }
    }
  }

  Future<void> _logout() async {
    try {
      await _userRepository.logoutUser();
      setState(() {
        _loggedInUser = null;
      });
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(
          content: Text('Wylogowano pomyślnie'),
        ),
      );
    } catch (e) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nie udało się wylogować'),
        ),
      );
    }
  }

  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
    _saveTheme(_isDarkTheme);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'KULA',
      theme: _isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: MyHomePage(
        title: 'KULA',
        toggleTheme: _toggleTheme,
        isDarkTheme: _isDarkTheme,
        loggedInUser: _loggedInUser,
        userRepository: _userRepository,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    required this.title,
    required this.toggleTheme,
    required this.isDarkTheme,
    required this.userRepository,
    this.loggedInUser,
    super.key,
  });
  final String title;
  final VoidCallback toggleTheme;
  final bool isDarkTheme;
  final UserModel? loggedInUser;
  final UserRepositoryImpl userRepository;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        width: 200,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.loggedInUser != null
                    ? 'Cześć, ${widget.loggedInUser!.name}!'
                    : 'Menu',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            if (widget.loggedInUser == null)
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Logowanie'),
                onTap: () {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const UserLoginRegisterWidget();
                    },
                  ).then((_) async {
                    await context
                        .findAncestorStateOfType<_MyAppState>()!
                        ._checkLoggedInUser();
                    setState(() {});
                  });
                },
              ),
            if (widget.loggedInUser != null)
              ListTile(
                leading: const Icon(Icons.list),
                title: const Text('Moje Sugestie'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SuggestionWidget(),
                    ),
                  );
                },
              ),
            ListTile(
              leading:
                  Icon(widget.isDarkTheme ? Icons.nights_stay : Icons.wb_sunny),
              title: const Text('Zmień motyw'),
              onTap: () {
                Navigator.of(context).pop(); // Close the drawer
                widget.toggleTheme();
              },
            ),
            if (widget.loggedInUser != null)
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Wyloguj się'),
                onTap: () async {
                  Navigator.of(context).pop(); // Close the drawer
                  await widget.userRepository.logoutUser();
                  await context
                      .findAncestorStateOfType<_MyAppState>()!
                      ._logout();
                  setState(() {});
                },
              ),
          ],
        ),
      ),
      body: Stack(
        children: [
          const Center(
            child: KebabPlaceMapWidget(),
          ),
          Positioned(
            bottom: 16.0,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return KebabPlaceWidget(
                          fillingRepository: FillingRepositoryImpl(
                            FillingDataSource(client: http.Client()),
                          ),
                          sauceRepository: SauceRepositoryImpl(
                            SauceDataSource(client: http.Client()),
                          ),
                        );
                      },
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(0.0, 1.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;

                        final tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        final offsetAnimation = animation.drive(tween);

                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
                child: const Text('LISTA'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
