import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/features/expense/presentation/pages/expense_list_screen.dart';

import '../entities/expense_entity.dart';
import '../repositories/expense_repository.dart';

class UpdateExpenseUseCase {
  final ExpenseRepository repository;

  UpdateExpenseUseCase(this.repository);

  Future<void> call(ExpenseEntity expense) async {
    if (expense.amount <= 0) {
      throw Exception('Amount must be greater than zero');
    }
    await repository.updateExpense(expense);

    Get.snackbar(
      'Success',
      'Expense updated successfully!',
      backgroundColor: Colors.green,
      snackPosition: SnackPosition.TOP,
    );

    Get.off(ExpenseListScreen());
  }
}