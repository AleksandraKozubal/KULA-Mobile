import 'package:kula_mobile/Data/Data_sources/filling_data_source.dart';
import 'package:kula_mobile/Data/Models/filling_model.dart';
import 'package:kula_mobile/Data/Repositories/filling_repository.dart';

class FillingRepositoryImpl implements FillingRepository {
  final FillingDataSource dataSource;

  FillingRepositoryImpl(this.dataSource);

  @override
  Future<List<FillingModel>> getFillings() async {
    return await dataSource.getFillings();
  }
}
