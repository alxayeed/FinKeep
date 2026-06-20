import 'package:finkeep/features/expense/data/models/expense_model.dart';
import 'package:finkeep/features/expense/data/datasources/expense_local_datasource.dart';
import 'package:finkeep/core/services/local_db_service.dart';
import 'package:finkeep/core/enums/payment_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseHiveDataSource implements ExpenseLocalDataSource {
  final LocalDbService localDb;

  ExpenseHiveDataSource({required this.localDb});

  DateTime _parseTimestamp(dynamic val) {
    if (val is DateTime) return val;
    if (val is Timestamp) return val.toDate();
    if (val is Map) {
      final seconds = val['_seconds'] ?? val['seconds'];
      final nanoseconds = val['_nanoseconds'] ?? val['nanoseconds'] ?? 0;
      if (seconds != null) {
        return Timestamp(seconds, nanoseconds).toDate();
      }
    }
    if (val is String) return DateTime.parse(val);
    return DateTime.now();
  }

  ExpenseModel _mapJson(Map<String, dynamic> json) =>
      ExpenseModel.fromJson(json);

  @override
  Future<void> createExpense(ExpenseModel expense) async {
    await localDb.expensesBox.put(expense.id, expense.toJson());
  }

  @override
  Future<ExpenseModel?> getExpenseById(String id) async {
    final raw = localDb.expensesBox.get(id);
    if (raw != null) {
      return _mapJson(Map<String, dynamic>.from(raw));
    }
    return null;
  }

  @override
  Future<List<ExpenseModel>> getExpenses() async {
    final list = localDb.expensesBox.values
        .map((raw) => _mapJson(Map<String, dynamic>.from(raw)))
        .toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  @override
  Future<void> updateExpense(ExpenseModel expense) async {
    await localDb.expensesBox.put(expense.id, expense.toJson());
  }

  @override
  Future<void> deleteExpense(String id) async {
    await localDb.expensesBox.delete(id);
  }

  @override
  Future<List<ExpenseModel>> getExpensesForMonth(
    DateTime selectedMonth,
  ) async {
    DateTime startOfMonth = DateTime(selectedMonth.year, selectedMonth.month, 1);
    DateTime endOfMonth = DateTime(selectedMonth.year, selectedMonth.month + 1, 1)
        .subtract(const Duration(seconds: 1));

    final list = localDb.expensesBox.values
        .map((raw) => _mapJson(Map<String, dynamic>.from(raw)))
        .where((expense) =>
            expense.date.isAfter(startOfMonth.subtract(const Duration(seconds: 1))) &&
            expense.date.isBefore(endOfMonth.add(const Duration(seconds: 1))))
        .toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  @override
  Future<List<ExpenseModel>> getExpensesInRange(
    DateTime start,
    DateTime end,
  ) async {
    final list = localDb.expensesBox.values
        .map((raw) => _mapJson(Map<String, dynamic>.from(raw)))
        .where((expense) =>
            expense.date.isAfter(start.subtract(const Duration(seconds: 1))) &&
            expense.date.isBefore(end.add(const Duration(seconds: 1))))
        .toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  @override
  Future<double> getTotalExpensesForMonth(
    DateTime selectedMonth,
  ) async {
    final expenses = await getExpensesForMonth(selectedMonth);
    return expenses.fold<double>(0.0, (acc, expense) => acc + expense.amount);
  }
}
