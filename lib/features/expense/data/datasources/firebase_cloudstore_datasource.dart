import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/config/app_config.dart';
import '../models/expense_model.dart';
import 'expense_remote_datasource.dart';

class FirebaseCloudStoreDataSource implements ExpenseRemoteDataSource {
  final FirebaseFirestore fireStore;
  late final CollectionReference<Map<String, dynamic>> _expensesCollection;

  FirebaseCloudStoreDataSource({required this.fireStore}) {
    _expensesCollection = fireStore.collection(
      AppConfig.isProd ? 'expenses' : 'expenses_dev',
    );
  }

  @override
  Future<void> createExpense(ExpenseModel expense) async {
    await _expensesCollection
        .doc(expense.id)
        .set(expense.toJson());
  }

  @override
  Future<ExpenseModel?> getExpenseById(String id) async {
    final snapshot = await _expensesCollection.doc(id).get();
    if (snapshot.exists) {
      return ExpenseModel.fromJson(snapshot.data()!);
    }
    return null;
  }

  @override
  Future<List<ExpenseModel>> getExpenses(String userId) async {
    final querySnapshot = await _expensesCollection
        .where('userId', isEqualTo: userId)
        .get();

    final list = querySnapshot.docs
        .map((doc) => ExpenseModel.fromJson(doc.data()..['id'] = doc.id))
        .toList();

    // Sort in-memory to avoid needing composite indexes in Firestore
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    await _expensesCollection
        .doc(expense.id)
        .update(expense.toJson());
  }

  @override
  Future<void> deleteExpense(String id) async {
    await _expensesCollection.doc(id).delete();
  }

  @override
  Future<List<ExpenseModel>> getExpensesForMonth(
    String userId,
    DateTime selectedMonth,
  ) async {
    DateTime startOfMonth = DateTime(
      selectedMonth.year,
      selectedMonth.month,
      1,
    );
    DateTime endOfMonth = DateTime(
      selectedMonth.year,
      selectedMonth.month + 1,
      1,
    ).subtract(const Duration(seconds: 1));

    final querySnapshot = await _expensesCollection
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: startOfMonth)
        .where('date', isLessThanOrEqualTo: endOfMonth)
        .get();

    final list = querySnapshot.docs
        .map((doc) => ExpenseModel.fromJson(doc.data()..['id'] = doc.id))
        .toList();

    // Sort in-memory to avoid needing composite indexes in Firestore
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  @override
  Future<double> getTotalExpensesForMonth(
    String userId,
    DateTime selectedMonth,
  ) async {
    DateTime startOfMonth = DateTime(
      selectedMonth.year,
      selectedMonth.month,
      1,
    );
    DateTime endOfMonth = DateTime(
      selectedMonth.year,
      selectedMonth.month + 1,
      1,
    ).subtract(const Duration(seconds: 1));

    final querySnapshot = await _expensesCollection
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: startOfMonth)
        .where('date', isLessThanOrEqualTo: endOfMonth)
        .get();

    double total = 0.0;
    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      final amount = data['amount'];
      if (amount is num) {
        total += amount.toDouble();
      }
    }

    return total;
  }

  @override
  Future<List<ExpenseModel>> getExpensesInRange(
    String userId,
    DateTime start,
    DateTime end,
  ) async {
    final querySnapshot = await _expensesCollection
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThanOrEqualTo: end)
        .get();

    final list = querySnapshot.docs
        .map((doc) => ExpenseModel.fromJson(doc.data()..['id'] = doc.id))
        .toList();

    // Sort in-memory to avoid needing composite indexes in Firestore
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }
}
