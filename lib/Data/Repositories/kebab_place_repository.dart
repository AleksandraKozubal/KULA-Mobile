import 'package:kula_mobile/Data/Models/kebab_place_model.dart';

abstract class KebabPlaceRepository {
  Future<List<KebabPlaceModel>> getKebabPlaces();
  Future<KebabPlaceModel> getKebabPlace(int id);
}
