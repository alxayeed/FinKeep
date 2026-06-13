import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/core/enums/expense_category.dart';
import 'expense_controller.dart';

class SetMonthlyBudgetController extends GetxController {
  final ExpenseController expenseController = Get.find();
  final DateTime month;

  var overallBudget = 30000.0.obs;
  var isRecurring = true.obs;
  var enabledCategories = <ExpenseCategory, bool>{}.obs;
  var categoryBudgets = <ExpenseCategory, double>{}.obs;

  late TextEditingController overallTextController;
  final categoryTextControllers = <ExpenseCategory, TextEditingController>{};

  SetMonthlyBudgetController({required this.month});

  @override
  void onInit() {
    super.onInit();
    final initialOverall = expenseController.monthlyBudget.value;
    overallBudget.value = initialOverall > 0 ? initialOverall : 30000.0;
    overallTextController = TextEditingController(text: overallBudget.value.toStringAsFixed(0));
    overallTextController.addListener(() {
      overallBudget.value = double.tryParse(overallTextController.text) ?? 0.0;
    });

    for (var category in ExpenseCategory.values) {
      final hasLimit = expenseController.categoryBudgets.containsKey(category);
      enabledCategories[category] = hasLimit;

      final limitVal = expenseController.categoryBudgets[category] ?? 0.0;
      categoryBudgets[category] = limitVal;

      final text = hasLimit ? limitVal.toStringAsFixed(0) : '';
      final textController = TextEditingController(text: text);
      categoryTextControllers[category] = textController;
      
      textController.addListener(() {
        final val = double.tryParse(textController.text) ?? 0.0;
        categoryBudgets[category] = val;
      });
    }
  }

  @override
  void onClose() {
    overallTextController.dispose();
    for (var c in categoryTextControllers.values) {
      c.dispose();
    }
    super.onClose();
  }

  double get totalCategorySum {
    double sum = 0.0;
    enabledCategories.forEach((cat, enabled) {
      if (enabled) {
        sum += categoryBudgets[cat] ?? 0.0;
      }
    });
    return sum;
  }

  bool get isExceeded => totalCategorySum > overallBudget.value;

  void toggleCategory(ExpenseCategory category, bool enabled) {
    enabledCategories[category] = enabled;
    if (!enabled) {
      categoryTextControllers[category]!.text = '';
      categoryBudgets[category] = 0.0;
    }
  }

  Future<void> saveBudget() async {
    double overall = double.tryParse(overallTextController.text) ?? 30000.0;
    if (overall <= 0) {
      overall = 30000.0;
    }

    final Map<ExpenseCategory, double> categories = {};
    enabledCategories.forEach((cat, enabled) {
      if (enabled) {
        final val = categoryBudgets[cat] ?? 0.0;
        if (val > 0) {
          categories[cat] = val;
        }
      }
    });

    final sum = categories.values.fold(0.0, (s, v) => s + v);
    if (sum > overall) {
      overall = sum;
    }

    await expenseController.saveBudgetsForMonth(
      month: month,
      overall: overall,
      categories: categories,
      isRecurring: isRecurring.value,
    );
  }
}
