import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/expense_model.dart';
import 'expense_remote_datasource.dart';

class FirebaseCloudStoreDataSource implements ExpenseRemoteDataSource {
  static final FirebaseCloudStoreDataSource _instance = FirebaseCloudStoreDataSource._internal();
  final FirebaseFirestore fireStore;

  factory FirebaseCloudStoreDataSource() {
    return _instance;
  }

  FirebaseCloudStoreDataSource._internal() : fireStore = FirebaseFirestore.instance;

  @override
  Future<void> createExpense(ExpenseModel expense) async {
    await fireStore
        .collection('expenses')
        .doc(expense.id)
        .set(expense.toJson());
  }

  @override
  Future<ExpenseModel?> getExpenseById(String id) async {
    final snapshot = await fireStore.collection('expenses').doc(id).get();
    if (snapshot.exists) {
      return ExpenseModel.fromJson(snapshot.data()!);
    }
    return null;
  }

  @override
  Future<List<ExpenseModel>> getExpenses(String userId) async {
    final querySnapshot = await fireStore
        .collection('expenses')
        .where('userId', isEqualTo: userId).orderBy("createdAt", descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => ExpenseModel.fromJson(doc.data()..['id'] = doc.id))
        .toList();
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    await fireStore
        .collection('expenses')
        .doc(expense.id)
        .update(expense.toJson());
  }

  @override
  Future<void> deleteExpense(String id) async {
    await fireStore.collection('expenses').doc(id).delete();
  }

  @override
  Future<List<ExpenseModel>> getExpensesForMonth(String userId, DateTime selectedMonth) async {
    DateTime startOfMonth = DateTime(selectedMonth.year, selectedMonth.month, 1);
    DateTime endOfMonth = DateTime(selectedMonth.year, selectedMonth.month + 1, 1).subtract(const Duration(seconds: 1));

    final querySnapshot = await fireStore
        .collection('expenses')
        .where('userId', isEqualTo: userId)
        .where('createdAt', isGreaterThanOrEqualTo: startOfMonth)
        .where('createdAt', isLessThanOrEqualTo: endOfMonth)
        .orderBy("createdAt", descending: true)
        .get();

    final result = querySnapshot.docs
        .map((doc) => ExpenseModel.fromJson(doc.data()..['id'] = doc.id))
        .toList();

    return result;
  }
}
