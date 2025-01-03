import 'package:kula_mobile/Data/Data_sources/kebab_place_data_source.dart';
import 'package:kula_mobile/Data/Models/kebab_place_model.dart';

class KebabPlaceRepositoryImpl {
  final KebabPlaceDataSource _dataSource;

  KebabPlaceRepositoryImpl(this._dataSource);

  Future<Map<String, dynamic>> getKebabPlaces({required int page}) async {
    return await _dataSource.getKebabPlaces(page: page);
  }

  Future<KebabPlaceModel> getKebabPlace(int id) async {
    return await _dataSource.getKebabPlace(id);
  }
}
