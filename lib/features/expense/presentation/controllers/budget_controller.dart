import 'package:finkeep/core/error/exception_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkeep/core/config/app_config.dart';
import 'package:finkeep/core/enums/expense_category.dart';
import 'package:intl/intl.dart';
import 'package:finkeep/core/services/local_db_service.dart';
import 'package:finkeep/features/expense/domain/repositories/expense_repository.dart';
import 'package:finkeep/features/expense/domain/entities/expense_entity.dart';

class PastMonthBudgetModel {
  final DateTime month;
  final double totalExpense;
  final TextEditingController budgetTextController;

  PastMonthBudgetModel({
    required this.month,
    required this.totalExpense,
    required double initialBudget,
  }) : budgetTextController = TextEditingController(
          text: initialBudget > 0 ? initialBudget.toStringAsFixed(0) : '',
        );
}

class BudgetController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final LocalDbService localDb = LocalDbService();

  // Persistent States
  var monthlyBudget = 0.0.obs;
  var categoryBudgets = <ExpenseCategory, double>{}.obs;
  var isBudgetLoading = false.obs;

  // Historical Budgets States
  var pastMonthsBudgets = <PastMonthBudgetModel>[].obs;
  var isPastMonthsLoading = false.obs;

  // UI / Form States for SetMonthlyBudgetScreen
  var overallBudget = 0.0.obs;
  var isRecurring = true.obs;
  var enabledCategories = <ExpenseCategory, bool>{}.obs;
  var tempCategoryBudgets = <ExpenseCategory, double>{}.obs;

  late TextEditingController overallTextController;
  final categoryTextControllers = <ExpenseCategory, TextEditingController>{};
  late DateTime targetMonth;



  void initUi(DateTime month) {
    targetMonth = month;
    final initialOverall = monthlyBudget.value;
    overallBudget.value = initialOverall;
    overallTextController = TextEditingController(text: overallBudget.value > 0 ? overallBudget.value.toStringAsFixed(0) : '0');
    overallTextController.addListener(() {
      overallBudget.value = double.tryParse(overallTextController.text) ?? 0.0;
    });

    for (var category in ExpenseCategory.values) {
      final hasLimit = categoryBudgets.containsKey(category);
      enabledCategories[category] = hasLimit;

      final limitVal = categoryBudgets[category] ?? 0.0;
      tempCategoryBudgets[category] = limitVal;

      final text = hasLimit ? limitVal.toStringAsFixed(0) : '';
      final textController = TextEditingController(text: text);
      categoryTextControllers[category] = textController;
      
      textController.addListener(() {
        final val = double.tryParse(textController.text) ?? 0.0;
        tempCategoryBudgets[category] = val;
      });
    }
  }

  void disposeUi() {
    overallTextController.dispose();
    for (var c in categoryTextControllers.values) {
      c.dispose();
    }
    categoryTextControllers.clear();
  }

  double get totalCategorySum {
    double sum = 0.0;
    enabledCategories.forEach((cat, enabled) {
      if (enabled) {
        sum += tempCategoryBudgets[cat] ?? 0.0;
      }
    });
    return sum;
  }

  bool get isExceeded => totalCategorySum > overallBudget.value;

  void toggleCategory(ExpenseCategory category, bool enabled) {
    enabledCategories[category] = enabled;
    if (!enabled) {
      categoryTextControllers[category]!.text = '';
      tempCategoryBudgets[category] = 0.0;
    }
  }

  Future<void> saveBudget() async {
    double overall = double.tryParse(overallTextController.text) ?? 0.0;

    final Map<ExpenseCategory, double> categories = {};
    enabledCategories.forEach((cat, enabled) {
      if (enabled) {
        final val = tempCategoryBudgets[cat] ?? 0.0;
        if (val > 0) {
          categories[cat] = val;
        }
      }
    });

    final sum = categories.values.fold(0.0, (s, v) => s + v);
    if (sum > overall) {
      overall = sum;
    }

    await saveBudgetsForMonth(
      month: targetMonth,
      overall: overall,
      categories: categories,
      isRecurring: isRecurring.value,
    );
  }

  Future<void> loadBudgetsForMonth(DateTime month) async {
    isBudgetLoading.value = true;
    try {
      final String monthDocId = DateFormat('yyyy-MMMM').format(month);
      final String recurringDocId = 'recurring';

      // 1. Try loading specific month budget from local Hive database first
      final localMonthData = localDb.budgetsBox.get(monthDocId);
      if (localMonthData != null) {
        _applyBudgetData(Map<String, dynamic>.from(localMonthData));
        return;
      }

      // 2. Try loading recurring budget baseline from local Hive database
      final localRecurData = localDb.budgetsBox.get(recurringDocId);
      if (localRecurData != null) {
        _applyBudgetData(Map<String, dynamic>.from(localRecurData));
        return;
      }

      // 3. Fetch from Firestore if personal mode and local is empty
      if (AppConfig.isPersonal) {
        final collectionName = AppConfig.get('FIRESTORE_SUFFIX').isEmpty ? 'budgets' : 'budgets${AppConfig.get('FIRESTORE_SUFFIX')}';
        
        final monthDoc = await firestore.collection(collectionName).doc(monthDocId).get();
        if (monthDoc.exists && monthDoc.data() != null) {
          final data = monthDoc.data()!;
          if (data['updatedAt'] is Timestamp) {
            data['updatedAt'] = (data['updatedAt'] as Timestamp).toDate().toIso8601String();
          }
          await localDb.budgetsBox.put(monthDocId, data);
          _applyBudgetData(data);
          return;
        }

        final recurringDoc = await firestore.collection(collectionName).doc(recurringDocId).get();
        if (recurringDoc.exists && recurringDoc.data() != null) {
          final data = recurringDoc.data()!;
          if (data['updatedAt'] is Timestamp) {
            data['updatedAt'] = (data['updatedAt'] as Timestamp).toDate().toIso8601String();
          }
          await localDb.budgetsBox.put(recurringDocId, data);
          _applyBudgetData(data);
          return;
        }
      }

      // 4. Fallback defaults
      _applyDefaultBudgets();
    } catch (e, stackTrace) {
      ExceptionHandler.handle(e, stackTrace, 'BudgetController.loadBudgetsForMonth');
      _applyDefaultBudgets();
    } finally {
      isBudgetLoading.value = false;
    }
  }

  void _applyBudgetData(Map<String, dynamic> data) {
    monthlyBudget.value = (data['overallBudget'] as num?)?.toDouble() ?? 0.0;
    final catBudgets = <ExpenseCategory, double>{};
    if (data['categoryBudgets'] is Map) {
      final map = data['categoryBudgets'] as Map;
      map.forEach((k, v) {
        final cat = ExpenseCategoryExtension.fromString(k.toString());
        catBudgets[cat] = (v as num).toDouble();
      });
    }
    categoryBudgets.value = catBudgets;
  }

  void _applyDefaultBudgets() {
    monthlyBudget.value = 0.0;
    categoryBudgets.value = {};
  }

  Future<void> saveBudgetsForMonth({
    required DateTime month,
    required double overall,
    required Map<ExpenseCategory, double> categories,
    required bool isRecurring,
  }) async {
    isBudgetLoading.value = true;
    try {
      final String monthDocId = DateFormat('yyyy-MMMM').format(month);
      final String recurringDocId = 'recurring';
      final docId = isRecurring ? recurringDocId : monthDocId;

      final categoryMap = <String, double>{};
      categories.forEach((k, v) {
        categoryMap[k.name] = v;
      });

      final budgetData = {
        'id': docId,
        'overallBudget': overall,
        'categoryBudgets': categoryMap,
        'isRecurring': isRecurring,
        'month': DateFormat('yyyy-MMMM').format(month),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      // Save locally (offline-first). Coexist with existing month/recurring docs instead of deleting them.
      await localDb.budgetsBox.put(docId, budgetData);

      // Propagate to Firestore if personal mode active
      if (AppConfig.isPersonal) {
        try {
          final collectionName = AppConfig.get('FIRESTORE_SUFFIX').isEmpty ? 'budgets' : 'budgets${AppConfig.get('FIRESTORE_SUFFIX')}';
          
          final firestoreData = {
            ...budgetData,
            'updatedAt': FieldValue.serverTimestamp(),
          };

          await firestore.collection(collectionName).doc(docId).set(firestoreData);
        } catch (e, stackTrace) {
          ExceptionHandler.handle(e, stackTrace, 'BudgetController.saveBudgetsForMonth - Firestore sync');
        }
      }

      monthlyBudget.value = overall;
      categoryBudgets.value = categories;
    } catch (e, stackTrace) {
      ExceptionHandler.handle(e, stackTrace, 'BudgetController.saveBudgetsForMonth');
    } finally {
      isBudgetLoading.value = false;
    }
  }

  Future<double> getBudgetForMonth(DateTime month) async {
    try {
      final String monthDocId = DateFormat('yyyy-MMMM').format(month);
      final String recurringDocId = 'recurring';

      // Try local cache first (specific month, then recurring baseline)
      final localMonthData = localDb.budgetsBox.get(monthDocId);
      if (localMonthData != null) {
        return (localMonthData['overallBudget'] as num?)?.toDouble() ?? 0.0;
      }

      final localRecurData = localDb.budgetsBox.get(recurringDocId);
      if (localRecurData != null) {
        return (localRecurData['overallBudget'] as num?)?.toDouble() ?? 0.0;
      }
    } catch (e, stackTrace) {
      ExceptionHandler.handle(e, stackTrace, 'BudgetController.getBudgetForMonth');
    }
    return 0.0;
  }

  void initPastMonthsBudgets() {
    isPastMonthsLoading.value = true;
    pastMonthsBudgets.clear();
  }

  Future<void> loadPastMonthsBudgets() async {
    isPastMonthsLoading.value = true;
    try {
      final now = DateTime.now();
      final currentMonthStart = DateTime(now.year, now.month, 1);

      // Fetch all expenses from repository (handles local vs remote)
      final repository = Get.find<ExpenseRepository>();
      final List<ExpenseEntity> allExpenses = await repository.getExpenses();

      // Group expenses by month (only previous months)
      final Map<DateTime, double> monthlyExpenses = {};
      for (var expense in allExpenses) {
        final monthStart = DateTime(expense.date.year, expense.date.month, 1);
        if (monthStart.isBefore(currentMonthStart)) {
          monthlyExpenses[monthStart] = (monthlyExpenses[monthStart] ?? 0.0) + expense.amount;
        }
      }

      // Sort months descending
      final sortedMonths = monthlyExpenses.keys.toList()..sort((a, b) => b.compareTo(a));

      final List<PastMonthBudgetModel> list = [];
      for (var month in sortedMonths) {
        final budget = await getBudgetForMonth(month);
        list.add(PastMonthBudgetModel(
          month: month,
          totalExpense: monthlyExpenses[month] ?? 0.0,
          initialBudget: budget,
        ));
      }

      pastMonthsBudgets.value = list;
    } catch (e, stackTrace) {
      ExceptionHandler.handle(e, stackTrace, 'BudgetController.loadPastMonthsBudgets');
    } finally {
      isPastMonthsLoading.value = false;
    }
  }

  Future<void> savePastMonthsBudgets() async {
    isPastMonthsLoading.value = true;
    try {
      for (var item in pastMonthsBudgets) {
        final budgetVal = double.tryParse(item.budgetTextController.text) ?? 0.0;
        final String monthDocId = DateFormat('yyyy-MMMM').format(item.month);
        
        // Preserve existing category budgets if present
        Map<ExpenseCategory, double> categories = {};
        final localData = localDb.budgetsBox.get(monthDocId) ?? localDb.budgetsBox.get('recurring');
        if (localData != null && localData['categoryBudgets'] is Map) {
          final map = localData['categoryBudgets'] as Map;
          map.forEach((k, v) {
            final cat = ExpenseCategoryExtension.fromString(k.toString());
            categories[cat] = (v as num).toDouble();
          });
        }

        await saveBudgetsForMonth(
          month: item.month,
          overall: budgetVal,
          categories: categories,
          isRecurring: false,
        );
      }
    } catch (e, stackTrace) {
      ExceptionHandler.handle(e, stackTrace, 'BudgetController.savePastMonthsBudgets');
    } finally {
      isPastMonthsLoading.value = false;
    }
  }
}
