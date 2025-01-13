import 'package:kula_mobile/Data/Data_sources/sauce_data_source.dart';
import 'package:kula_mobile/Data/Models/sauce_model.dart';

class SauceRepositoryImpl {
  final SauceDataSource dataSource;

  SauceRepositoryImpl(this.dataSource);

  Future<List<SauceModel>> getSauces() async {
    return await dataSource.getSauces();
  }
}
