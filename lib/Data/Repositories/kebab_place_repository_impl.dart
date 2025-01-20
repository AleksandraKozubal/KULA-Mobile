import 'package:kula_mobile/Data/Data_sources/kebab_place_data_source.dart';
import 'package:kula_mobile/Data/Models/kebab_place_model.dart';

class KebabPlaceRepositoryImpl {
  final KebabPlaceDataSource _dataSource;

  KebabPlaceRepositoryImpl(this._dataSource);

  Future<Map<String, dynamic>> getKebabPlaces({
    required int page,
    int? paginate,
    String? fchain,
    String? fcraft,
    String? fdatetime,
    List<int>? ffillings,
    String? flocation,
    String? fopen,
    String? fordering,
    List<int>? fsauces,
    String? fstatus,
    String? sby,
    String? sdirection,
  }) async {
    return await _dataSource.getKebabPlaces(
      page: page,
      paginate: paginate,
      fchain: fchain,
      fcraft: fcraft,
      fdatetime: fdatetime,
      ffillings: ffillings,
      flocation: flocation,
      fopen: fopen,
      fordering: fordering,
      fsauces: fsauces,
      fstatus: fstatus,
      sby: sby,
      sdirection: sdirection,
    );
  }

  Future<KebabPlaceModel> getKebabPlace(int id) async {
    return await _dataSource.getKebabPlace(id);
  }
}
