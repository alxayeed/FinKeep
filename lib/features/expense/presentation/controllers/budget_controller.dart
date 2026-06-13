import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spendly/core/config/app_config.dart';
import 'package:spendly/core/enums/expense_category.dart';
import 'package:intl/intl.dart';
import 'package:spendly/features/auth/presentation/controller/auth_controller.dart';
import 'package:spendly/core/services/local_db_service.dart';

class BudgetController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final AuthController authController = Get.find();
  final LocalDbService localDb = LocalDbService();

  // Persistent States
  var monthlyBudget = 30000.0.obs;
  var categoryBudgets = <ExpenseCategory, double>{}.obs;
  var isBudgetLoading = false.obs;

  // UI / Form States for SetMonthlyBudgetScreen
  var overallBudget = 30000.0.obs;
  var isRecurring = true.obs;
  var enabledCategories = <ExpenseCategory, bool>{}.obs;
  var tempCategoryBudgets = <ExpenseCategory, double>{}.obs;

  late TextEditingController overallTextController;
  final categoryTextControllers = <ExpenseCategory, TextEditingController>{};
  late DateTime targetMonth;

  String get userId => authController.user?.email ?? '';

  void initUi(DateTime month) {
    targetMonth = month;
    final initialOverall = monthlyBudget.value;
    overallBudget.value = initialOverall > 0 ? initialOverall : 30000.0;
    overallTextController = TextEditingController(text: overallBudget.value.toStringAsFixed(0));
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
    double overall = double.tryParse(overallTextController.text) ?? 30000.0;
    if (overall <= 0) {
      overall = 30000.0;
    }

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
    if (userId.isEmpty) return;
    isBudgetLoading.value = true;
    try {
      final String monthDocId = '${userId}_${DateFormat('yyyy-MMMM').format(month)}';
      final String recurringDocId = '${userId}_recurring';

      // 1. Try loading from local Hive database first
      final localMonthData = localDb.budgetsBox.get(monthDocId);
      if (localMonthData != null) {
        _applyBudgetData(Map<String, dynamic>.from(localMonthData));
        return;
      }

      final now = DateTime.now();
      final currentMonthStart = DateTime(now.year, now.month);
      final targetMonthStart = DateTime(month.year, month.month);
      if (!targetMonthStart.isBefore(currentMonthStart)) {
        final localRecurData = localDb.budgetsBox.get(recurringDocId);
        if (localRecurData != null) {
          _applyBudgetData(Map<String, dynamic>.from(localRecurData));
          return;
        }
      }

      // 2. Fetch from Firestore if personal mode and local is empty
      if (AppConfig.isPersonal) {
        final collectionName = AppConfig.get('FIRESTORE_SUFFIX').isEmpty ? 'budgets' : 'budgets${AppConfig.get('FIRESTORE_SUFFIX')}';
        
        final monthDoc = await firestore.collection(collectionName).doc(monthDocId).get();
        if (monthDoc.exists && monthDoc.data() != null) {
          final data = monthDoc.data()!;
          await localDb.budgetsBox.put(monthDocId, data);
          _applyBudgetData(data);
          return;
        }

        if (!targetMonthStart.isBefore(currentMonthStart)) {
          final recurringDoc = await firestore.collection(collectionName).doc(recurringDocId).get();
          if (recurringDoc.exists && recurringDoc.data() != null) {
            final data = recurringDoc.data()!;
            await localDb.budgetsBox.put(recurringDocId, data);
            _applyBudgetData(data);
            return;
          }
        }
      }

      // 3. Fallback defaults
      _applyDefaultBudgets();
    } catch (e) {
      log('Error loading budget: $e');
      _applyDefaultBudgets();
    } finally {
      isBudgetLoading.value = false;
    }
  }

  void _applyBudgetData(Map<String, dynamic> data) {
    monthlyBudget.value = (data['overallBudget'] as num?)?.toDouble() ?? 30000.0;
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
    monthlyBudget.value = 30000.0;
    categoryBudgets.value = {
      ExpenseCategory.family: 12000.0,
      ExpenseCategory.personal: 5000.0,
      ExpenseCategory.transport: 3000.0,
      ExpenseCategory.food: 2500.0,
      ExpenseCategory.utilities: 1500.0,
      ExpenseCategory.lend: 1500.0,
      ExpenseCategory.clothing: 1500.0,
      ExpenseCategory.hangout: 1500.0,
      ExpenseCategory.other: 1500.0,
    };
  }

  Future<void> saveBudgetsForMonth({
    required DateTime month,
    required double overall,
    required Map<ExpenseCategory, double> categories,
    required bool isRecurring,
  }) async {
    if (userId.isEmpty) return;
    isBudgetLoading.value = true;
    try {
      final String monthDocId = '${userId}_${DateFormat('yyyy-MMMM').format(month)}';
      final String recurringDocId = '${userId}_recurring';

      final categoryMap = <String, double>{};
      categories.forEach((k, v) {
        categoryMap[k.name] = v;
      });

      final budgetData = {
        'id': isRecurring ? recurringDocId : monthDocId,
        'userId': userId,
        'overallBudget': overall,
        'categoryBudgets': categoryMap,
        'isRecurring': isRecurring,
        'month': DateFormat('yyyy-MMMM').format(month),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      // Save locally first (offline-first)
      if (isRecurring) {
        await localDb.budgetsBox.put(recurringDocId, budgetData);
        await localDb.budgetsBox.delete(monthDocId);
      } else {
        await localDb.budgetsBox.put(monthDocId, budgetData);
        await localDb.budgetsBox.delete(recurringDocId);
      }

      // Propagate to Firestore if personal mode active
      if (AppConfig.isPersonal) {
        try {
          final collectionName = AppConfig.get('FIRESTORE_SUFFIX').isEmpty ? 'budgets' : 'budgets${AppConfig.get('FIRESTORE_SUFFIX')}';
          
          final firestoreData = {
            ...budgetData,
            'updatedAt': FieldValue.serverTimestamp(),
          };

          if (isRecurring) {
            await firestore.collection(collectionName).doc(recurringDocId).set(firestoreData);
            try {
              await firestore.collection(collectionName).doc(monthDocId).delete();
            } catch (_) {}
          } else {
            await firestore.collection(collectionName).doc(monthDocId).set(firestoreData);
            try {
              await firestore.collection(collectionName).doc(recurringDocId).delete();
            } catch (_) {}
          }
        } catch (e) {
          log('Firestore budget sync failed (handled silently offline-first): $e');
        }
      }

      monthlyBudget.value = overall;
      categoryBudgets.value = categories;
    } catch (e) {
      log('Error saving budget: $e');
    } finally {
      isBudgetLoading.value = false;
    }
  }

  Future<double> getBudgetForMonth(DateTime month) async {
    if (userId.isEmpty) return 30000.0;
    try {
      final String monthDocId = '${userId}_${DateFormat('yyyy-MMMM').format(month)}';
      final String recurringDocId = '${userId}_recurring';

      // Try local cache first
      final localMonthData = localDb.budgetsBox.get(monthDocId);
      if (localMonthData != null) {
        return (localMonthData['overallBudget'] as num?)?.toDouble() ?? 30000.0;
      }

      final now = DateTime.now();
      final currentMonthStart = DateTime(now.year, now.month);
      final targetMonthStart = DateTime(month.year, month.month);
      if (!targetMonthStart.isBefore(currentMonthStart)) {
        final localRecurData = localDb.budgetsBox.get(recurringDocId);
        if (localRecurData != null) {
          return (localRecurData['overallBudget'] as num?)?.toDouble() ?? 30000.0;
        }
      }
    } catch (e) {
      log('Error getting budget for month: $e');
    }
    return 30000.0;
  }
}
