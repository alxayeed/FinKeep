import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkeep/core/config/app_config.dart';
import 'package:finkeep/features/income/data/models/income/income_model.dart';
import 'package:finkeep/features/income/data/models/income_category/income_category_model.dart';
import 'income_remote_datasource.dart';

class IncomeFirestoreDataSource implements IncomeRemoteDataSource {
  final FirebaseFirestore firestore;
  late final CollectionReference<Map<String, dynamic>> _incomeCollection;
  late final CollectionReference<Map<String, dynamic>> _categoriesCollection;

  IncomeFirestoreDataSource({required this.firestore}) {
    _incomeCollection = firestore.collection(
      AppConfig.isPersonal ? 'income' : 'income_dev',
    );
    _categoriesCollection = firestore.collection(
      AppConfig.isPersonal ? 'income_categories' : 'income_categories_dev',
    );
  }

  // --- Income CRUD ---
  @override
  Future<void> createIncome(IncomeModel income) async {
    await _incomeCollection.doc(income.id).set(income.toFirestoreMap());
  }

  @override
  Future<IncomeModel?> getIncomeById(String id) async {
    final snapshot = await _incomeCollection.doc(id).get();
    if (snapshot.exists && snapshot.data() != null) {
      return IncomeModel.fromFirestoreMap(snapshot.data()!..['id'] = snapshot.id);
    }
    return null;
  }

  @override
  Future<List<IncomeModel>> getIncomes() async {
    final snapshot = await _incomeCollection.get();
    final list = snapshot.docs
        .map((doc) => IncomeModel.fromFirestoreMap(doc.data()..['id'] = doc.id))
        .toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  @override
  Future<void> updateIncome(IncomeModel income) async {
    await _incomeCollection.doc(income.id).update(income.toFirestoreMap());
  }

  @override
  Future<void> deleteIncome(String id) async {
    await _incomeCollection.doc(id).delete();
  }

  @override
  Future<List<IncomeModel>> getIncomesForMonth(DateTime selectedMonth) async {
    DateTime startOfMonth = DateTime(selectedMonth.year, selectedMonth.month, 1);
    DateTime endOfMonth = DateTime(selectedMonth.year, selectedMonth.month + 1, 1)
        .subtract(const Duration(seconds: 1));

    final snapshot = await _incomeCollection
        .where('date', isGreaterThanOrEqualTo: startOfMonth)
        .where('date', isLessThanOrEqualTo: endOfMonth)
        .get();

    final list = snapshot.docs
        .map((doc) => IncomeModel.fromFirestoreMap(doc.data()..['id'] = doc.id))
        .toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  @override
  Future<List<IncomeModel>> getIncomesInRange(DateTime start, DateTime end) async {
    final snapshot = await _incomeCollection
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThanOrEqualTo: end)
        .get();

    final list = snapshot.docs
        .map((doc) => IncomeModel.fromFirestoreMap(doc.data()..['id'] = doc.id))
        .toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  @override
  Future<double> getTotalIncomesForMonth(DateTime selectedMonth) async {
    DateTime startOfMonth = DateTime(selectedMonth.year, selectedMonth.month, 1);
    DateTime endOfMonth = DateTime(selectedMonth.year, selectedMonth.month + 1, 1)
        .subtract(const Duration(seconds: 1));

    final snapshot = await _incomeCollection
        .where('date', isGreaterThanOrEqualTo: startOfMonth)
        .where('date', isLessThanOrEqualTo: endOfMonth)
        .get();

    double total = 0.0;
    for (var doc in snapshot.docs) {
      final amount = doc.data()['amount'];
      if (amount is num) {
        total += amount.toDouble();
      }
    }
    return total;
  }

  // --- Category CRUD ---
  @override
  Future<void> createCategory(IncomeCategoryModel category) async {
    await _categoriesCollection.doc(category.id).set(category.toFirestoreMap());
  }

  @override
  Future<List<IncomeCategoryModel>> getCategories() async {
    final snapshot = await _categoriesCollection.get();
    return snapshot.docs
        .map((doc) => IncomeCategoryModel.fromFirestoreMap(doc.data()..['id'] = doc.id))
        .toList();
  }

  @override
  Future<void> updateCategory(IncomeCategoryModel category) async {
    await _categoriesCollection.doc(category.id).update(category.toFirestoreMap());
  }

  @override
  Future<void> deleteCategory(String id) async {
    final snapshot = await _categoriesCollection.doc(id).get();
    if (snapshot.exists && snapshot.data() != null) {
      final category = IncomeCategoryModel.fromFirestoreMap(snapshot.data()!..['id'] = snapshot.id);
      final updated = category.copyWith(isDeleted: true);
      await _categoriesCollection.doc(id).update(updated.toFirestoreMap());
    }
  }
}
