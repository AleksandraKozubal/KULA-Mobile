import 'package:kula_mobile/Data/Models/sauce_model.dart';

abstract class SauceRepository {
  Future<List<SauceModel>> getSauces();
}
