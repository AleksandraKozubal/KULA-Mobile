import 'package:kula_mobile/Data/Data_sources/kebab_place_data_source.dart';
import 'package:kula_mobile/Data/Models/kebab_place_model.dart';

class KebabPlaceRepositoryImpl {
  final KebabPlaceDataSource _dataSource;

  KebabPlaceRepositoryImpl(this._dataSource);

  Future<List<KebabPlaceModel>> getKebabPlaces() async {
    return _dataSource.getKebabPlaces();
  }

  Future<KebabPlaceModel> getKebabPlace(int id) async {
    return _dataSource.getKebabPlace(id);
  }
}