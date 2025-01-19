import 'package:kula_mobile/Data/Data_sources/favorite_data_source.dart';

class FavoriteRepositoryImpl {
  final FavoriteDataSource favoriteDataSource;

  FavoriteRepositoryImpl({required this.favoriteDataSource});

  Future<void> favoriteKebabPlace(String id) async {
    await favoriteDataSource.favoriteKebabPlace(id);
  }

  Future<void> unfavoriteKebabPlace(String id) async {
    await favoriteDataSource.unfavoriteKebabPlace(id);
  }

  Future<bool> isKebabPlaceFavorited(String id) async {
    return await favoriteDataSource.isKebabPlaceFavorited(id);
  }
}
