import 'package:kula_mobile/Data/Models/filling_model.dart';

abstract class FillingRepository {
  Future<List<FillingModel>> getFillings();
}
