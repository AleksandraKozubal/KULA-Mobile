import 'package:kula_mobile/Data/Data_sources/suggestion_data_source.dart';
import 'package:kula_mobile/Data/Models/suggestion_model.dart';

class SuggestionRepositoryImpl {
  final SuggestionDataSource suggestionDataSource;

  SuggestionRepositoryImpl({required this.suggestionDataSource});

  Future<List<SuggestionModel>> fetchSuggestions() {
    return suggestionDataSource.fetchSuggestions();
  }

  Future<void> addSuggestion(
    int kebabPlaceId,
    String name,
    String description,
  ) {
    return suggestionDataSource.addSuggestion(kebabPlaceId, name, description);
  }
}
