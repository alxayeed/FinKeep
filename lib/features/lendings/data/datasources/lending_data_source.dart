import 'package:spendly/features/lendings/data/models/lending_model.dart';

abstract class LendingDataSource {
  Future<List<LendingModel>> getAllLendings();
}
