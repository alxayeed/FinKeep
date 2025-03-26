import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spendly/core/constants/app_strings.dart';
import 'package:spendly/core/error/exceptions.dart';
import 'package:spendly/features/lendings/data/models/lending_model.dart';

import 'lending_data_source.dart';

//TODO: Add tests for this
//TODO: add other exceptions
class LendingFirestoreDataSource implements LendingDataSource {
  final FirebaseFirestore firestore;

  LendingFirestoreDataSource({required this.firestore});

  @override
  Future<List<LendingModel>> getAllLendings() async {
    try {
      final querySnapshot =
          await firestore.collection(AppStrings.lendingsCollection).get();

      // Map the query snapshot to LendingModel list
      final lendings = querySnapshot.docs.map((doc) {
        return LendingModel.fromJson(doc.data());
      }).toList();

      return lendings;
    } catch (e) {
      throw ServerException(message: '${AppStrings.internalServerError}: $e');
    }
  }
}
