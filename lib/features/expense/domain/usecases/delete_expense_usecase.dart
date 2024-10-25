import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/core/routes/app_routes.dart';

import '../repositories/expense_repository.dart';

class DeleteExpenseUseCase {
  final ExpenseRepository repository;

  DeleteExpenseUseCase(this.repository);

  Future<void> call(String id) async {
    if (id.isEmpty) {
      throw Exception('Invalid ID');
    }
    await repository.deleteExpense(id);

    Get.snackbar(
      'Success',
      'Expense deleted successfully!',
      backgroundColor: Colors.red,
      snackPosition: SnackPosition.TOP,
    );

    Get.toNamed(AppRoutes.expenses);

  }
}