import 'package:flutter/material.dart';
import 'package:kula_mobile/Data/Data_sources/login_data_source.dart';
import 'package:kula_mobile/Data/Data_sources/logout_data_source.dart';
import 'package:kula_mobile/Data/Data_sources/register_data_source.dart';
import 'package:kula_mobile/Data/Repositories/suggestion_repository_impl.dart';
import 'package:kula_mobile/Data/Data_sources/suggestion_data_source.dart';
import 'package:kula_mobile/Data/Models/suggestion_model.dart';
import 'package:kula_mobile/Widgets/badge_widget.dart';
import 'package:kula_mobile/Services/token_storage.dart';
import 'package:kula_mobile/Data/Models/user_model.dart';
import 'package:kula_mobile/Data/Repositories/user_repository_impl.dart';
import 'package:kula_mobile/Data/Data_sources/user_data_source.dart';
import 'package:http/http.dart' as http;

class SuggestionWidget extends StatefulWidget {
  const SuggestionWidget({super.key});

  @override
  SuggestionWidgetState createState() => SuggestionWidgetState();
}

class SuggestionWidgetState extends State<SuggestionWidget> {
  late SuggestionRepositoryImpl suggestionRepository;
  late UserRepositoryImpl userRepository;
  late Future<List<SuggestionModel>> suggestionsFuture;
  UserModel? _loggedInUser;

  @override
  void initState() {
    super.initState();
    final suggestionDataSource = SuggestionDataSource();
    suggestionRepository =
        SuggestionRepositoryImpl(suggestionDataSource: suggestionDataSource);
    userRepository = UserRepositoryImpl(
      userDataSource: UserDataSource(client: http.Client()),
      registerDataSource: RegisterDataSource(client: http.Client()),
      loginDataSource: LoginDataSource(client: http.Client()),
      logoutDataSource: LogoutDataSource(client: http.Client()),
    );
    suggestionsFuture = Future.value([]);
    _checkLoggedInUser();
  }

  Future<void> _checkLoggedInUser() async {
    final token = await TokenStorage.getToken();
    if (token != null) {
      final user = await userRepository.userDataSource.getUserData(token);
      setState(() {
        _loggedInUser = user;
        suggestionsFuture = suggestionRepository.fetchSuggestions();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moje Sugestie'),
      ),
      body: FutureBuilder<List<SuggestionModel>>(
        future: suggestionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final suggestions = snapshot.data!
                .where((suggestion) => suggestion.userId == _loggedInUser?.id)
                .toList();
            if (suggestions.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Na razie nic nie zostało zasugerowane.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final suggestion = suggestions[index];
                return ListTile(
                  title: Text(suggestion.name),
                  subtitle: Text(suggestion.description),
                  trailing: BadgeWidget(
                    text: suggestion.status,
                    color: suggestion.status == 'zaakceptowane'
                        ? Colors.green
                        : suggestion.status == 'odrzucone'
                            ? Colors.red
                            : Colors.orange,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
