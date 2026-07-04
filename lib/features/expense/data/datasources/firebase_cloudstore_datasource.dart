import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/config/app_config.dart';
import '../models/expense_model.dart';
import '../models/expense_category_model.dart';
import 'expense_remote_datasource.dart';

class FirebaseCloudStoreDataSource implements ExpenseRemoteDataSource {
  final FirebaseFirestore fireStore;
  late final CollectionReference<Map<String, dynamic>> _expensesCollection;
  late final CollectionReference<Map<String, dynamic>> _categoriesCollection;

  FirebaseCloudStoreDataSource({required this.fireStore}) {
    _expensesCollection = fireStore.collection(
      AppConfig.isPersonal ? 'expenses' : 'expenses_dev',
    );
    _categoriesCollection = fireStore.collection(
      AppConfig.isPersonal ? 'expense_categories' : 'expense_categories_dev',
    );
  }

  // --- Category CRUD ---
  @override
  Future<void> createCategory(ExpenseCategoryModel category) async {
    await _categoriesCollection.doc(category.id).set(category.toFirestoreMap());
  }

  @override
  Future<List<ExpenseCategoryModel>> getCategories() async {
    final snapshot = await _categoriesCollection.get();
    if (snapshot.docs.isEmpty) {
      final defaults = [
        const ExpenseCategoryModel(id: 'exp_food', displayLabel: 'Food', emoji: '🍔', isCustom: false),
        const ExpenseCategoryModel(id: 'exp_transport', displayLabel: 'Transport', emoji: '🚗', isCustom: false),
        const ExpenseCategoryModel(id: 'exp_family', displayLabel: 'Family', emoji: '🏠', isCustom: false),
        const ExpenseCategoryModel(id: 'exp_personal', displayLabel: 'Personal', emoji: '👤', isCustom: false),
        const ExpenseCategoryModel(id: 'exp_clothing', displayLabel: 'Clothing', emoji: '👕', isCustom: false),
        const ExpenseCategoryModel(id: 'exp_hangout', displayLabel: 'Travelling', emoji: '✈️', isCustom: false),
        const ExpenseCategoryModel(id: 'exp_utilities', displayLabel: 'Utilities', emoji: '⚡', isCustom: false),
        const ExpenseCategoryModel(id: 'exp_other', displayLabel: 'Other', emoji: '📦', isCustom: false),
      ];
      for (final cat in defaults) {
        await _categoriesCollection.doc(cat.id).set(cat.toFirestoreMap());
      }
      return defaults;
    }
    return snapshot.docs
        .map((doc) => ExpenseCategoryModel.fromFirestoreMap(doc.data()..['id'] = doc.id))
        .toList();
  }

  @override
  Future<void> updateCategory(ExpenseCategoryModel category) async {
    await _categoriesCollection.doc(category.id).update(category.toFirestoreMap());
  }

  @override
  Future<void> deleteCategory(String id) async {
    final snapshot = await _categoriesCollection.doc(id).get();
    if (snapshot.exists && snapshot.data() != null) {
      final category = ExpenseCategoryModel.fromFirestoreMap(snapshot.data()!..['id'] = snapshot.id);
      final updated = category.copyWith(isDeleted: true);
      await _categoriesCollection.doc(id).update(updated.toFirestoreMap());
    }
  }

  @override
  Future<void> createExpense(ExpenseModel expense) async {
    await _expensesCollection.doc(expense.id).set(expense.toFirestoreMap());
  }

  @override
  Future<ExpenseModel?> getExpenseById(String id) async {
    final snapshot = await _expensesCollection.doc(id).get();
    if (snapshot.exists) {
      return ExpenseModel.fromFirestoreMap(snapshot.data()!);
    }
    return null;
  }

  @override
  Future<List<ExpenseModel>> getExpenses() async {
    final querySnapshot = await _expensesCollection.get();

    final list = querySnapshot.docs
        .map(
          (doc) => ExpenseModel.fromFirestoreMap(doc.data()..['id'] = doc.id),
        )
        .toList();

    // Sort in-memory to avoid needing composite indexes in Firestore
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    await _expensesCollection.doc(expense.id).update(expense.toFirestoreMap());
  }

  @override
  Future<void> deleteExpense(String id) async {
    await _expensesCollection.doc(id).delete();
  }

  @override
  Future<List<ExpenseModel>> getExpensesForMonth(
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
        .where('date', isGreaterThanOrEqualTo: startOfMonth)
        .where('date', isLessThanOrEqualTo: endOfMonth)
        .get();

    final list = querySnapshot.docs
        .map(
          (doc) => ExpenseModel.fromFirestoreMap(doc.data()..['id'] = doc.id),
        )
        .toList();

    // Sort in-memory to avoid needing composite indexes in Firestore
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  @override
  Future<double> getTotalExpensesForMonth(
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
    DateTime start,
    DateTime end,
  ) async {
    final querySnapshot = await _expensesCollection
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThanOrEqualTo: end)
        .get();

    final list = querySnapshot.docs
        .map(
          (doc) => ExpenseModel.fromFirestoreMap(doc.data()..['id'] = doc.id),
        )
        .toList();

    // Sort in-memory to avoid needing composite indexes in Firestore
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }
}
