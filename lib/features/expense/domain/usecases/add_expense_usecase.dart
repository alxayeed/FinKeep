import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../entities/expense_entity.dart';
import '../repositories/expense_repository.dart';

class AddExpenseUseCase {
  final ExpenseRepository repository;

  AddExpenseUseCase(this.repository);

  Future<void> call(ExpenseEntity expense) async {
    if (expense.amount <= 0) {
      throw Exception('Amount must be greater than zero');
    }
    await repository.addExpense(expense);

    Get.snackbar(
      'Success',
      'Expense added successfully!',
      backgroundColor: Colors.green,
      snackPosition: SnackPosition.TOP,
    );

  }
}
